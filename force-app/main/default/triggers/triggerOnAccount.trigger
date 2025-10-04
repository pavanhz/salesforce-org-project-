trigger triggerOnAccount on Account (before insert , before update , after insert , after update , after delete , before delete ) {
		
    if( trigger.isbefore && trigger.isInsert){
        triggerOnAccountHandler.PopulateRating( trigger.new);
    }
    
    if(trigger.isbefore){
        if(trigger.isinsert){
            triggerOnAccountHandler.BeforeAccountInsert(trigger.new);
        }
    }
    
   /* if( trigger.isbefore ){
        if (trigger.isdelete){																	Code thik se chal raha hai , Practice karne keliye code 
            triggerOnAccountHandler.PreventAccountDeletation( trigger.old);						code ko comment kiya hai .
        }
    }
   */
    if(trigger.isafter && trigger.isinsert){
        triggerOnAccountHandler.CreateRealtedOpporunity(trigger.new);
    }
    if(trigger.isafter && trigger.isinsert){
        triggerOnAccountHandler.CreateRealtedContact(trigger.new);
    }
    
    if(trigger.isafter && trigger.isupdate){
        triggerOnAccountHandler.UpdateRealtedOpportunity(trigger.new , trigger.oldMap);
    }
    
    if( trigger.isafter && trigger.isupdate ){
        triggerOnAccountHandler.UpdateRealtedContact( trigger.new , trigger.oldMap);
    }
    
    if( trigger.isbefore && trigger.isInsert){
        triggerOnAccountHandler.DuplicateAccount( trigger.new);
    }
    
   /* if( trigger.isbefore && trigger.isdelete){
        triggerOnAccountHandler.CheckUser( trigger.new);
    }
   */
    
   
}