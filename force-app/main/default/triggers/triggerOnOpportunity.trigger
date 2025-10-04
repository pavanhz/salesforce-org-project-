trigger triggerOnOpportunity on Opportunity (before insert , after insert , after delete ) {
    
    if( trigger.isbefore && trigger.isinsert){
        triggerOnOpportunityaHandler.AvoidDuplicateRecords( trigger.new);
    }
	
    if( trigger.isafter && trigger.isinsert){
        triggerOnOpportunityaHandler.CountOpporunityOnAccount( trigger.new);
    }
    
        if( trigger.isafter && trigger.isdelete){
        triggerOnOpportunityaHandler.CountOpporunityOnAccount( trigger.old);
    }
    
    // Utility Method to Count Both Contact and Opportunity in same filed 
	
    if( trigger.isinsert && trigger.isafter){
  		triggerOnOpportunityaHandler.UpdateCountOnAccount( trigger.new);
    }
    
    if( trigger.isafter && trigger.isUpdate ){
		triggerOnOpportunityaHandler.UpdateCountOnAccount( trigger.new );
    }
    
    if( trigger.isafter && trigger.isdelete){
        triggerOnOpportunityaHandler.UpdateCountOnAccount(trigger.old);
    }
    
    
}