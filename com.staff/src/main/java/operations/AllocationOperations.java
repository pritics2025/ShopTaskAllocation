package operations;

import model.Allocation;
import java.util.List;


public interface AllocationOperations {

	 public boolean addAllocation(Allocation allocation);
	    public List<Allocation> getAllocationsByUser (int userId);
	    public boolean updateAllocationStatus(int allocationId, String status, String comments);
	    public List<Allocation> getAllAllocations();  // For admin view
		public boolean updateAllocation(Allocation alloc);
		public boolean deleteAllocation(int allocationId);
	   
	
}
