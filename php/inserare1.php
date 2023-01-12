<html>
<head>
  <title>Inserare client</title>
</head>
<body>
<h1>inserare client</h1>



<?php

  // datele din formular
  $nume=$_POST['nume'];
  $oras=$_POST['oras'];
  $tel=$_POST['telefon'];

 
  if (!$nume || !$oras|| !$tel)
  {
    echo 'nu ai com pletat toate casutele.<br />';
     exit;
  }


if( preg_match('/^[a-z \\-]{1,}$/i', $nume) == 0 ){
echo 'numele contine numai litere, spatiu gol sau cratima';
exit;
}

if( preg_match('/^[0-9]{1,}$/i', $tel) == 0 ){
echo 'telefonul contine numai cifre';
exit;
}

if( preg_match('/^[a-z ]{1,}$/i', $oras) == 0 ){
echo 'orasul contine numai litere, spatiu gol';
exit;
}



  @ $db = new mysqli('localhost', 'webuser1', 'webuser1', 'lib5');





  if (mysqli_connect_errno()) 
  {
     echo 'Error: Conexiunea la serverul mysql nu s-a facut. Incercati mai tarziu';
     exit;
  }



  $query = "insert into clienti(nume, oras,telefon) values 
            ('".$nume."', '".$oras."', '".$tel."');"; 

echo $query;
echo "<br>";

  $result = $db->query($query);

  if ($result)
       echo  $db->affected_rows.' client introdus.'; 


  $db->close();


?>





</body>
</html>
