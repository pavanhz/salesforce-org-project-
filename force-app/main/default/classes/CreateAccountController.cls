public class CreateAccountController {
    
    public Account acclist {get ; set ; }
    	
    public CreateAccountController(){
        
        acclist = new Account();
        
    }

    public pagereference CreateAcc(){
        
        insert acclist ;
        
        return new pagereference('/'+ acclist.id).setRedirect(true);
    }
    
    public pagereference cancleMehtod(){
        
     return new pagereference('/'+ acclist.id).setRedirect(true);

        
    }
}