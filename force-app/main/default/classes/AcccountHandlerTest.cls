@isTest
public class AcccountHandlerTest {

    @isTest
    public static void PopulateRating(){
        List<Account> accountlist = new List<Account>();
        
        for(integer i= 1 ; i<= 3 ; i++){
            Account acc  = new Account();
            
            acc.Name = 'Account_'+ i ; 
            acc.Industry = 'Government';
            accountlist.add(acc);
            
        }
        test.starttest();
        insert accountlist ; 
        test.stoptest();
        
            	List<Account> updateAcclist = [ select id , Name , Industry , CustomerPriority__c ,Rating , type from Account where Id IN:accountlist] ;
   				 for( Account ac : updateAcclist){
                    System.assertEquals('Government', ac.Industry, 'Industry should be Government');
                     System.assertEquals( 'High' , ac.CustomerPriority__c , 'CustomerPriority should be High');
                     System.assertEquals( 'Prospect' , ac.type , 'type should be Prospect');
   				}    	
    }
    	

}