m = $.modifiers[1]
select (for o in objects where finditem o.modifiers m != 0 collect o)