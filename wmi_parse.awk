BEGIN {
 
 init_val = 0

 init_val_cmd = 0
 
 FS = " *= *"  

 flag = 0
}

/HHHHHHHHHHHHHHHHHHHHHHHHHH/ {
  
   flag = 1
   init_val_cmd = 0
   next


}

/GGGGGGGGGGGGGGGGG/ {

  flag = 2
  init_val_event = 0
  next

}

/EEEEEEEEEEEEEEEEEEEEEE/ {

  flag = 3
  for (iter in dict) {
     tmp = sprintf("%x",dict[iter])
     #print iter , tmp
     dict_inv[tmp] = iter

  }

  for (iter in dict_inv) {
    print iter, dict_inv[iter]

  }

  next
}

/\**(.|\n)*\*/ {

  next
}

/^[ \n]*$/ {
   next
}

/^ *WMI_GRP_/ && (flag == 0) {

   gsub(/ /,"");
   if ((NF == 2)&& ishex($2)) {

     init_val = $2
     #print init_val 
     #print "dddddddd", $1
     
     dict[$1] = init_val++
     #print "FFFFFFFF" , dict[$1]


   } else if ((NF == 2) && isnum($2)) {
      init_val = $2
      #print "ssss"
      dict[$1] = init_val++
   }
   else if (NF == 2) {
      #print $1, $2, dict[$2]
      
      dict[$1] = dict[$2]
      init_val = dict[$2]
      init_val++
      #print "GGGGGGG"
      #print $2 
   }
   else {
      #print init_val
      dict[$1] = init_val++
   }
   #print init_val

}

flag == 1 {

   gsub(/ /,"");
   #print $0
   if ((NF == 2)&& ishex($2)) {
     #print "111111  ", $0
     init_val_cmd = $2
     #print init_val 
     #print "dddddddd", $1
     
     dict[$1] = init_val_cmd++
     #print "FFFFFFFF" , dict[$1] 

   } else if ((NF == 2) && isnum($2)) {
      #print "222222   ", $0
      init_val_cmd = $2
      #print "ssss"
      dict[$1] = init_val_cmd++
   }
   else if (NF == 2) {
      #print "333333   ",$0
      #print $1, $2, dict[$2]
      #print $1, $2
      if ($2 ~ /WMI_CMD_GRP_START_ID|WMI_EVT_GRP_START_ID/) {
          #print $1, $2
          gsub("WMI_CMD_GRP_START_ID|WMI_EVT_GRP_START_ID","",$2)
          gsub(/[)]/,"",$2)
          gsub(/[(]/,"",$2)
          init_val_cmd = getinitval(dict[$2])
          dict[$1]= init_val_cmd;
          init_val_cmd++
      } else {

          init_val_cmd = dict[$2]
          dict[$1] = init_val_cmd
          init_val_cmd++
          
      }
   }
   else {
      #print init_val
      dict[$1] = init_val_cmd++
   }
   #print init_val_cmd

  

}
flag == 2 {

   gsub(/ /,"");
   #print $0
   if ((NF == 2)&& ishex($2)) {
     #print "111111  ", $0
     init_val_event = $2
     #print init_val 
     #print "dddddddd", $1
     
     dict[$1] = init_val_event++
     #print "FFFFFFFF" , dict[$1] 

   } else if ((NF == 2) && isnum($2)) {
      #print "222222   ", $0
      init_val_event = $2
      #print "ssss"
      dict[$1] = init_val_event++
   }
   else if (NF == 2) {
      #print "333333   ",$0
      #print $1, $2, dict[$2]
      #print $1, $2
      if ($2 ~ /WMI_CMD_GRP_START_ID|WMI_EVT_GRP_START_ID/) {
          #print $1, $2
          gsub("WMI_CMD_GRP_START_ID|WMI_EVT_GRP_START_ID","",$2)
          gsub(/[)]/,"",$2)
          gsub(/[(]/,"",$2)
          init_val_event = getinitval(dict[$2])
          dict[$1]= init_val_event;
          init_val_event++
      } else {

          init_val_cmd = dict[$2]
          dict[$1] = init_val_event
          init_val_event
          
      }
   }
   else {
      #print init_val
      dict[$1] = init_val_event++
   }
   #print init_val_cmd

  

}

flag == 3 {

  if ($1 ~ /CMD ID/) {
     
     iter = $2 ""
     #print iter
     #print dict_inv[iter]

   }   


}

END{

  #for (iter in dict) {
  #   tmp = sprintf("%x",dict[iter])
     #print iter , tmp
  #   dict_inv[tmp] = iter

  #}

  #for (iter in dict_inv) {
  #  print iter, dict_inv[iter]

  #}

}

function getinitval(grp_id) {

   return ((grp_id) * 2^12) + 0x1;

}

function isnum(n) {

  return n ~ /^[0-9]+$/
}

function ishex(n) {
  return n ~ /^0x[0-9]+$/
}
