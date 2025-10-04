public class AccountWrapper {
    public List<Accwrapper> accwraplist {get ; set ; }
    public List<Account> acclist {get ; set ; }
    
    public AccountWrapper(){
       accwraplist = new List<Accwrapper>();
        acclist = new List<Account>();
        for(Account ac : [select id , Name ,phone ,industry from account ]){
            accwraplist.add(new Accwrapper(ac));
        }
    }

    public class Accwrapper{
        public Boolean ischeck {get ; set ; }
        public account acc {get ;set ;}
        
        public Accwrapper(account accholdvalue){
            acc = accholdvalue ;
            ischeck = false ; 
        }
    }
    
    public void selectedvalue(){
        for(Accwrapper wr : accwraplist ){
            if(wr.ischeck == true){
                acclist.add(wr.acc);
                wr.ischeck = false ; 
            }
            
        }
        
    }
        
        
  }