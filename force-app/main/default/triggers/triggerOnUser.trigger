trigger triggerOnUser on User (before insert , after insert ) {
	
    if( trigger.isbefore && trigger.isinsert ){
        triggerOnUserHandler.CheckUSerProfile( trigger.new);
    }
    
    if( trigger.isafter && trigger.isinsert ){
        triggerOnUserHandler.AssigneTakeTouser( trigger.new);
    }
}