package operations;

import model.Setting;
import java.util.List;

public interface SettingsOperations {
    List<Setting> getAllSettings();
    boolean updateSetting(Setting setting);
    Setting getSettingByKey(String key);
}
