trigger triggerOnContact on Contact (before insert , after insert  , after delete , after undelete ) {
	
    if( trigger.isInsert && trigger.isAfter ){
            triggerOnContactHander.SendEmailOnContactCreation( trigger.new);
    }
    
    if( trigger.isInsert && trigger.isbefore){
        triggerOnContactHander.DuplicatRecordhandler( trigger.new);
    }
    
    if( trigger.isafter && trigger.isinsert){
        triggerOnContactHander.CountRelatedContact( trigger.new);
    }
    if( trigger.isafter &&  trigger.isDelete){
        triggerOnContactHander.CountRelatedContact( trigger.old);
    }
	
    // Utility Method to Count Both Contact and Opportunity in same filed 
    // 
    // After insert → update counts
    if (Trigger.isAfter && Trigger.isInsert) {
        triggerOnContactHander.updateCountsOnAccount(Trigger.new);
    }

    // After update → update counts (optional, only if AccountId changes)
    if (Trigger.isAfter && Trigger.isUpdate) {
        triggerOnContactHander.updateCountsOnAccount(Trigger.new);
    }

    // After delete → update counts
    if (Trigger.isAfter && Trigger.isDelete) {
        triggerOnContactHander.updateCountsOnAccount(Trigger.old);
    }

    
}