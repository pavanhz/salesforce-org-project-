public class Contactwrapper {
    public List<conwrapper> Wrapperlist { get ; set ;}
    public List<Contact> conlist { get ; set ; }
    
    public Contactwrapper (){
        Wrapperlist = new List<conwrapper>();
        conlist = new List<Contact>();
        for(Contact con : [select id , Name , lastName , phone , Email From Contact] ){
            Wrapperlist.add(new conwrapper (con ));
        }
        
    }
    
    public void SelectedContact(){
        for(conwrapper wrap : Wrapperlist ){
            if (wrap.ischeck== true){
                conlist.add(wrap.con);
            }
            wrap.ischeck = false ; 
        }
       
       
    }
    
    public class conwrapper{
        public Boolean ischeck { get ;set ;}
        public Contact con  {get ; set ; }
        
        public conwrapper( Contact Convalue ){
            
            con = Convalue;
            ischeck = false ; 
          
        }
    }
    
    
    

}