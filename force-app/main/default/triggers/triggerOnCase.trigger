trigger triggerOnCase on Case (before insert , after Insert , after delete , after undelete , after update  ) {
    
    if( trigger.isinsert && trigger.isafter){
        triggerOnCase.CountOnContact( trigger.new);
    }
}