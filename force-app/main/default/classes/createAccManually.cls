public class createAccManually {
	
    public void demo(){
        
        Account acc = new Account();
        acc.Name = 'Acc3';        
        acc.Phone= '3333';
        
        insert acc ; 
        System.debug('Account is ==>' + acc);
        
        Contact con = new Contact();
        con.FirstName = 'Contact';
        con.LastName = '2';
        con.Phone = '000000';
        
        insert con ; 
        
        System.debug('Contact is ==>' + con );
    }
    
    
}