<?php
    $poker = range(1,52);   //生成撲克牌陣列

   
    
    echo "<p>洗牌前</p>";
    echo "<table border='1'>";     //洗牌前的撲克牌表格
    for($i=0;$i<4;$i++){
        echo "<tr>";
        for($j=0;$j<13;$j++){
            echo "<td>{$poker[$j+(13*$i)]}";
            
        }
    }
    echo "</table>";

    $tmp = 0;     //交換用的暫存變數
    for($i=51;$i>0;$i--){       //洗牌
        $x=rand(0,$i);
        $tmp=$poker[$x];
        $poker[$x]=$poker[$i];
        $poker[$i]=$tmp;
    }

    echo "<p>洗牌後</p>";      //洗牌後的撲克牌表格
    echo "<table border='1'>";
    for($i=0;$i<4;$i++){
        echo "<tr>";
        for($j=0;$j<13;$j++){
            echo "<td>{$poker[$j+(13*$i)]}";
            
        }
    }
    echo "</table>";
   
    ?>
