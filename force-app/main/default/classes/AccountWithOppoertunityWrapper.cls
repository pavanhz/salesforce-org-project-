public class AccountWithOppoertunityWrapper {
    public List<Accountwrapper> wrapperlist {get ; set ; }
    public List<Accountwrapper> acclist {get ; set ; }
    
    public AccountWithOppoertunityWrapper(){
        wrapperlist = new List<Accountwrapper>();
        acclist = new List<Accountwrapper>();
        for( Account acc : [select id , name , phone , Industry from Account]){
            
            wrapperlist.add(new Accountwrapper (acc));
            
        }
        
    }
    public void SelectAccount(){
        acclist = new List<Accountwrapper>();
        
        for(Accountwrapper wrap : wrapperlist){
            if(wrap.ischeck == true){
                wrap.opplist = [SELECT Id, Name, CloseDate, StageName FROM Opportunity WHERE AccountId = :wrap.acc.id];
                acclist.add(wrap);
            }
            wrap.ischeck = false ; 
        }
    }
    
    public class Accountwrapper{
        public Account acc {get ; set ; }
        public Boolean ischeck { get ; set ;}
        public List<Opportunity> opplist {get ; set ; }
        
        public Accountwrapper(Account acc){
            this.acc = acc ; 
            this.ischeck = false ; 
            this.opplist = new List<Opportunity>();
            
        }
        
    }
    

}