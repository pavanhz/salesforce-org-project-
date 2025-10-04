public class triggerOnUserHandler {
    // Check User Profile add If the Profile is System Administator 
    public static void CheckUSerProfile( List<user> Userlist){
        
        Id AdiminProfileId = [ select id , Name From Profile where Name =: 'System Adminstraor'].Id ;
        
        Group Admingrop = [ select id From Group where DeveloperName =: 'salesforce_admin' Limit 1 ];
        
        List<GroupMember> grpMember = new List<GroupMember>();
        
        for( User us : Userlist){
            if( us.ProfileId == AdiminProfileId){
                grpMember.add(new GroupMember(
                	GroupId = Admingrop.Id , 
                    UserOrGroupId = us.Id 
                    
                ));
            }
        }
        If( !grpMember.isEmpty()){
            insert grpMember ; 
        }
        
	}
    
    // If User Profile is Sysytem Administrator Then assigne a task 
    public static void AssigneTakeTouser( List<User> userlist){
         Id sysadminstator = [select id From Profile where Name =: 'System Administrator '].Id ; 
         List<Task> tasklist = new List<Task>();
         
        for( user us : userlist ){
            if( us.Profileid == sysadminstator ){
                tasklist.add( new task(
                 OwnerId = us.Id ,
                    Subject = ' Complete Orianted to System Administrator Profile ' ,
                    	ActivityDate  = Date.Today().addDays(2),
                    		Priority  = 'High',
                    			Status = 'Not Started '
                	));
            }
        }
            if( !tasklist.isEmpty()){
                insert tasklist ; 
            }
                    
        
        
    }

}