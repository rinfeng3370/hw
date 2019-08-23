<head>
    <style>
        body{
            background-color:rgb(255,248,215);
        }
        table{
            margin : 5% auto;
            border-collapse:collapse;
        }


     </style>   




</head>
<h1>1到100 質數</h1>
<table border="1"  width="100%"  style="text-align: center">

        <?php
            define("min",1);    
            define("max",100);  //定義要計算的最大值


            $check=array_fill(min,max,0);  
            /*
            $check array  先把裡面都填滿0  
            如果計算出來是質數會把該值對應的index 設為一
            */


            for($x=2;$x<=max;$x++){    //計算是否為質數
                $pn=1;

                for($y=2;$y<$x;$y++){
                    if($x % $y == 0){
                        $pn=0;
                        break;
                    }
                }
                if($pn == 1){         //如果為質數會把$check對應的index設為1
                    
                    $check[$x] = 1;

                }

            }
            

            $number1 = min;           //生成表格

                    for($j=1;$j<=max;$j++){
                        if($j % 10 == 1){
                            echo "<tr >";
                        }
                        
                        if($check[$number1] == 1){
                            echo " <td height='50px' bgcolor='goldnrod'> {$number1} </td>";
                        }else{
                            echo " <td height='50px'> {$number1} </td>";
                        }
                        $number1 ++ ;
                    }
                    

                    echo "</tr>";
                




            ?>







</table>