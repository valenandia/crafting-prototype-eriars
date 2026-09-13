/// scr_book

function get_failure_chance_by_tags(_tag_count) {
    
    switch (_tag_count) {
        case 1:
            return 1;
            
        case 2:
            return 10;
            
        case 3:
            return 20;
            
        case 4:
            return 30;
            
        case 5:
            return 40;
    }
    
    return 40;
}


function get_knowledge_bonus(_discovered_count) {
    
    // Пока каждое изученное изделие уменьшает
    // шанс ошибки на 2 процентных пункта.
    
    return _discovered_count * 2;
}


function get_final_failure_chance(_tag_count, _discovered_count) {
    
    var base_chance = get_failure_chance_by_tags(_tag_count);
    var knowledge_bonus = get_knowledge_bonus(_discovered_count);
    
    return max(0, base_chance - knowledge_bonus);
}