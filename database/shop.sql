-- =====================================
-- DATABASE NAME: STASYNC - Staff Task Allocation Website
-- =====================================
DROP DATABASE IF EXISTS STASYNC;
CREATE DATABASE IF NOT EXISTS STASYNC;
USE STASYNC;

-- =====================================
-- 1) Authentication MODEL
-- Create USERS table for authentication OF BOTH ADMIN AND STAFF
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,  -- In production, store hashed passwords (e.g., bcrypt)
    role ENUM('admin', 'staff') NOT NULL,
    name VARCHAR(100) NOT NULL,
    contact VARCHAR(15)
);

-- Trigger for password length check (INSERT)
DELIMITER $$
CREATE TRIGGER check_password_length_User_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.password) < 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 8 characters';
    END IF;
END$$
DELIMITER ;

-- Trigger for password length check (UPDATE)
DELIMITER $$
CREATE TRIGGER check_password_length_User_update
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF CHAR_LENGTH(NEW.password) < 8 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Password must be at least 8 characters';
    END IF;
END$$
DELIMITER ;

-- =====================================
-- 2) PROFILE MANAGEMENT MODULE (Edit, Update, Delete Profile)
DELIMITER $$
CREATE PROCEDURE manage_users_profile (
    IN p_user_id INT,
    IN new_password VARCHAR(100),
    IN new_name VARCHAR(100),
    IN action_type ENUM('edit', 'update_password', 'update_name', 'delete')
)
BEGIN
    DECLARE user_exists INT DEFAULT 0;
    DECLARE user_role ENUM('admin', 'staff');

    -- Check if user exists and get role
    SELECT COUNT(*), role INTO user_exists, user_role 
    FROM users WHERE user_id = p_user_id;

    IF user_exists = 0 THEN
        SELECT 'User  not found.' AS message;
    ELSEIF action_type = 'delete' AND user_role = 'admin' THEN  -- Prevent deleting admins
        SELECT 'Cannot delete admin users.' AS message;
    ELSE
        CASE action_type
            WHEN 'edit' THEN
                SELECT user_id, username, role, name, contact 
                FROM users WHERE user_id = p_user_id;

            WHEN 'update_password' THEN
                IF new_password IS NOT NULL AND LENGTH(new_password) >= 8 THEN
                    UPDATE users SET password = new_password WHERE user_id = p_user_id;
                    SELECT 'Password updated for user' AS message;
                ELSE
                    SELECT 'Invalid new password. Must be at least 8 characters.' AS message;
                END IF;

            WHEN 'update_name' THEN
                IF new_name IS NOT NULL AND LENGTH(new_name) > 0 THEN
                    UPDATE users SET name = new_name WHERE user_id = p_user_id;
                    SELECT 'Name updated for user' AS message;
                ELSE
                    SELECT 'Invalid new name.' AS message;
                END IF;

            WHEN 'delete' THEN
                DELETE FROM users WHERE user_id = p_user_id;
                SELECT 'User  profile deleted' AS message;
        END CASE;
    END IF;
END$$
DELIMITER ;

-- =====================================
-- 3) ADMIN PANEL MODULE
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    task_name VARCHAR(100) NOT NULL,	
    description TEXT,
    deadline DATETIME,
    priority ENUM('low', 'medium', 'high'),
    task_type ENUM('Inventory', 'Billing', 'Support') DEFAULT 'Inventory',
    admin_id INT,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON DELETE SET NULL
    -- No CHECK constraint: Use triggers below or app validation for deadline > CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_tasks_deadline ON tasks(deadline);
CREATE INDEX idx_tasks_admin ON tasks(admin_id);

-- Optional: Triggers for deadline validation (uncomment to enable DB-enforced future deadlines)
 DELIMITER $$
 CREATE TRIGGER validate_task_deadline_insert
 BEFORE INSERT ON tasks
FOR EACH ROW
BEGIN
    IF NEW.deadline IS NOT NULL AND NEW.deadline <= CURRENT_TIMESTAMP THEN
         SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Deadline must be in the future';
     END IF;
END$$
 DELIMITER ;
-- 
DELIMITER $$
 CREATE TRIGGER validate_task_deadline_update
 BEFORE UPDATE ON tasks
FOR EACH ROW
 BEGIN
  IF NEW.deadline IS NOT NULL AND NEW.deadline <= CURRENT_TIMESTAMP THEN
       SIGNAL SQLSTATE '45000'
         SET MESSAGE_TEXT = 'Deadline must be in the future';
     END IF;
 END$$
 DELIMITER ;

-- =====================================
-- 4) STAFF PANEL MODULE
CREATE TABLE allocations (
    allocation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    task_id INT,
    status ENUM('Pending', 'In-Progress', 'Completed') NOT NULL,
    assigned_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    completion_date DATETIME,
    comments TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX idx_allocations_status ON allocations(status);
CREATE INDEX idx_allocations_user_task ON allocations(user_id, task_id);

-- =====================================
-- 5) NOTIFICATION MODULE
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    message TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Index for performance
CREATE INDEX idx_notifications_user ON notifications(user_id, is_read);

-- Trigger for new allocation notifications (improved: safe against NULLs)
DELIMITER $$
CREATE TRIGGER trg_new_task_alert
AFTER INSERT ON allocations
FOR EACH ROW
BEGIN
    DECLARE task_deadline DATETIME DEFAULT NULL;
    DECLARE hours_to_deadline INT DEFAULT NULL;
    DECLARE task_name VARCHAR(100) DEFAULT 'Unknown Task';

    -- Safe subqueries to get task details (COALESCE handles missing data)
    SET task_name = COALESCE((SELECT task_name FROM tasks WHERE task_id = NEW.task_id), 'Unknown Task');
    SET task_deadline = (SELECT deadline FROM tasks WHERE task_id = NEW.task_id);

    IF task_deadline IS NOT NULL THEN
        SET hours_to_deadline = TIMESTAMPDIFF(HOUR, CURRENT_TIMESTAMP, task_deadline);
    END IF;

    -- Insert notification if pending or urgent (<24 hours)
    IF NEW.status = 'Pending' 
       OR (hours_to_deadline IS NOT NULL AND hours_to_deadline < 24) 
    THEN
        INSERT INTO notifications (user_id, message)
        VALUES (NEW.user_id,
                COALESCE(
                    CONCAT('New task assigned: ', task_name, 
                           '. Deadline: ', COALESCE(task_deadline, 'None'),
                           CASE WHEN hours_to_deadline IS NOT NULL AND hours_to_deadline < 24 
                                THEN CONCAT(' (Urgent: ', hours_to_deadline, ' hours left!)') 
                                ELSE '' END),
                    'Task assigned (details unavailable).'
                )
               );
    END IF;
END$$
DELIMITER ;


CREATE TABLE activity_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    activity_type VARCHAR(50) NOT NULL,
    activity_description TEXT NOT NULL,
    activity_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

CREATE TABLE task_comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    comment_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE task_attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    upload_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
-- =====================================

-- Test Data (Ensures notifications trigger correctly)
-- Insert users
INSERT INTO users (username, password, role, name) VALUES ('priti1223', 'password123', 'staff', 'priti1223');
INSERT INTO users (username, password, role, name) VALUES ('admin', 'adminpass123', 'admin', 'Admin User');
INSERT INTO users (username, password, role, name) VALUES ('priti1223', 'password123', 'staff', 'priti1223');
INSERT INTO users (username, password, role, name) VALUES ('admin', 'adminpass123', 'admin', 'Admin User');

INSERT INTO users (username, password, role, name) VALUES ('user1', 'password1', 'staff', 'User One');
INSERT INTO users (username, password, role, name) VALUES ('user2', 'password2', 'staff', 'User Two');
INSERT INTO users (username, password, role, name) VALUES ('user3', 'password3', 'staff', 'User Three');
INSERT INTO users (username, password, role, name) VALUES ('user4', 'password4', 'staff', 'User Four');
INSERT INTO users (username, password, role, name) VALUES ('user5', 'password5', 'staff', 'User Five');
INSERT INTO users (username, password, role, name) VALUES ('user6', 'password6', 'staff', 'User Six');
INSERT INTO users (username, password, role, name) VALUES ('user7', 'password7', 'staff', 'User Seven');
INSERT INTO users (username, password, role, name) VALUES ('user8', 'password8', 'staff', 'User Eight');
INSERT INTO users (username, password, role, name) VALUES ('user9', 'password9', 'staff', 'User Nine');
select * from users;
-- Insert task (future deadline for urgency test)
INSERT INTO tasks (task_name, deadline, task_type, admin_id, priority) 
VALUES ('Check Inventory', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 HOUR), 'Inventory', 2, 'high');

INSERT INTO tasks (task_name, deadline, task_type, admin_id, priority) VALUES
('Check Inventory 1', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 1 HOUR), 'Inventory', 2, 'high')  ,
('Check Inventory 2', DATE_ADD(current_timestamp(), INTERVAL 2 HOUR), 'Inventory', 2, 'high'),
('Check Inventory 3', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 3 HOUR), 'Inventory', 2, 'high'),
('Check Inventory 4', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 4 HOUR), 'Inventory', 2, 'high'),
('Check Inventory 5', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 5 HOUR), 'Inventory', 2, 'high'),
('Check Inventory 6', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 6 HOUR), 'Inventory', 2, 'high'),
('Check Inventory 7', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 7 HOUR), 'Inventory', 2, 'high'),
('Check Inventory 8', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 8 HOUR), 'Inventory', 2, 'high'),
('Check Inventory 9', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 9 HOUR), 'Inventory', 2, 'high'),
('Check Inventory 10', DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 10 HOUR), 'Inventory', 2, 'high');

-- Insert allocation (this triggers the notification)
INSERT INTO allocations (user_id, task_id, status, comments) 
VALUES (1, 1, 'Pending', 'Started checking stock');

INSERT INTO allocations (user_id, task_id, status, comments) VALUES
(1, 1, 'Pending', 'Started checking stock 1'),
(1, 2, 'Pending', 'Started checking stock 2'),
(1, 3, 'Pending', 'Started checking stock 3'),
(1, 4, 'Pending', 'Started checking stock 4'),
(1, 5, 'Pending', 'Started checking stock 5'),
(1, 6, 'Pending', 'Started checking stock 6'),
(1, 7, 'Pending', 'Started checking stock 7'),
(1, 8, 'Pending', 'Started checking stock 8'),
(1, 9, 'Pending', 'Started checking stock 9'),
(1, 10, 'Pending', 'Started checking stock 10');

-- =====================================
-- Verification Queries (Run these to check everything works)
SELECT 'USERS TABLE' AS Section;
SELECT * FROM users;

SELECT 'TASKS TABLE' AS Section;
SELECT * FROM tasks;

SELECT 'ALLOCATIONS TABLE' AS Section;
SELECT * FROM allocations;

SELECT 'NOTIFICATIONS TABLE' AS Section;
SELECT * FROM notifications;  -- Should show 1 row with message like "New task assigned: Check Inventory. Deadline: ... (Urgent: ~1 hours left!)"

-- Test Procedure Example (Update staff name)
SELECT 'TESTING PROCEDURE' AS Section;
CALL manage_users_profile(1, NULL, 'Updated Test User', 'update_name');
SELECT * FROM users WHERE user_id = 1;  -- Name should be updated

-- =====================================
-- Cleanup (Run separately for reset - DO NOT RUN WITH MAIN SCRIPT)
-- DROP TRIGGER IF EXISTS trg_new_task_alert;
-- DROP TRIGGER IF EXISTS validate_task_deadline_insert;
-- DROP TRIGGER IF EXISTS validate_task_deadline_update;
-- DROP TRIGGER IF EXISTS check_password_length_User_insert;
-- DROP TRIGGER IF EXISTS check_password_length_User_update;
-- DROP PROCEDURE IF EXISTS manage_users_profile;
-- DROP DATABASE STASYNC;

-- Add a task (if none)
INSERT INTO tasks (task_name, description, priority, task_type, deadline, admin_id) 
VALUES ('Test Inventory Check', 'Check stock levels', 'high', 'Inventory', '2025-12-31 23:59', 1);

-- Get task_id (assume it's 1)
SELECT task_id FROM tasks WHERE task_name = 'Test Inventory Check';

-- Add allocation to staff (userId=2)
INSERT INTO allocations (task_id, user_id, status, assigned_date, comments) 
VALUES (1, 2, 'Pending', NOW(), 'Urgent stock check');

-- Add unread notification
SELECT * FROM users WHERE username = 'newusername';
SELECT * FROM users WHERE username = 'test user1';



