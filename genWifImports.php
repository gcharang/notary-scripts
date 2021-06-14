<?php

function errHandle($errNo, $errStr, $errFile, $errLine) {
    $msg = "$errStr in $errFile on line $errLine";
    if ($errNo == E_NOTICE || $errNo == E_WARNING) {
        throw new ErrorException($msg, $errNo);
    } else {
        echo $msg;
    }
}

set_error_handler('errHandle');

// https://github.com/BitcoinPHP/BitcoinECDSA.php
require_once 'BitcoinECDSA.php/src/BitcoinPHP/BitcoinECDSA/BitcoinECDSA.php';
use BitcoinPHP\BitcoinECDSA\BitcoinECDSA;

require_once 'Keccak256.php';
use Keccak\Keccak256;

/* ETH EIP55 implementation (2 variants) */
/* https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md */
function bytesToBits(string $bytestring) {
  if ($bytestring === '') return '';

  $bitstring = '';
  foreach (str_split($bytestring, 4) as $chunk) {
    $bitstring .= str_pad(base_convert(unpack('H*', $chunk)[1], 16, 2), strlen($chunk) * 8, '0', STR_PAD_LEFT);
  }
  return $bitstring;
}

function EIP55_1($address) {
$address_eip55 = ""; $kec = new Keccak256();
$addressHash = $kec->hash(strtolower($address), 256);
$addressHashBits = bytesToBits(pack("H*",$addressHash));
for ($i = 0; $i < 40; $i++ ) {
$c = $address[$i];
if (ctype_alpha($address{$i})) {
        if ($addressHashBits[4 * $i] == "1") $c = strtoupper($c);
}
$address_eip55 .= $c;
}
return $address_eip55;
}

function EIP55_2($address) {
$address_eip55 = ""; $kec = new Keccak256();
$addressHash = $kec->hash(strtolower($address), 256);
for ($i = 0; $i < 40; $i++ ) {
	if (intval($addressHash[$i], 16) >=8) $address_eip55 .= strtoupper($address[$i]); else $address_eip55 .= strtolower($address[$i]);
}
return $address_eip55;
}
/* ETH EIP55 implementation ------------ */

class BitcoinECDSADecker extends BitcoinECDSA {

    /***
     * Tests if the address is valid or not.
     *
     * @param string $address (base58)
     * @return bool
     */
    public function validateAddress($address)
    {
        $address    = hex2bin($this->base58_decode($address));

        /*
        if(strlen($address) !== 25)
            return false;
        $checksum   = substr($address, 21, 4);
        $rawAddress = substr($address, 0, 21);
	*/

	$len = strlen($address);
        $checksum   = substr($address, $len-4, 4);
        $rawAddress = substr($address, 0, $len-4);

        if(substr(hex2bin($this->hash256($rawAddress)), 0, 4) === $checksum)
            return true;
        else
            return false;
    }

    /**
     * Returns the current network prefix for WIF, '80' = main network, 'ef' = test network.
     *
     * @return string (hexa)
     */
    public function getPrivatePrefix($PrivatePrefix = 128){

        if($this->networkPrefix =='6f')
            return 'ef';
        else
           return sprintf("%02X",$PrivatePrefix);
    }
    /***
     * returns the private key under the Wallet Import Format
     *
     * @return string (base58)
     * @throws \Exception
     */

    public function getWIF($compressed = true, $PrivatePrefix = 128)
    {
        if(!isset($this->k))
        {
            throw new \Exception('No Private Key was defined');
        }

        $k          = $this->k;
        
        while(strlen($k) < 64)
            $k = '0' . $k;
        
        $secretKey  =  $this->getPrivatePrefix($PrivatePrefix) . $k;
        
        if($compressed) {
            $secretKey .= '01';
        }
        
        $secretKey .= substr($this->hash256(hex2bin($secretKey)), 0, 8);

        return $this->base58_encode($secretKey);
    }
}

$bitcoinECDSA = new BitcoinECDSADecker();

$config = parse_ini_file("config");

/*
$passphrase = "myverysecretandstrongpassphrase_noneabletobrute";
 */
$passphrase = $config["passphrase"];

/* available coins, you can add your own with params from src/chainparams.cpp */

$coins = Array(
    Array("name" => "BTC",  "PUBKEY_ADDRESS" =>  0, "SECRET_KEY" => 128 , "cli" => "bitcoin-cli"), 
    Array("name" => "LTC",  "PUBKEY_ADDRESS" =>  48, "SECRET_KEY" => 176 , "cli" => "litecoin-cli"),
    Array("name" => "KMD",  "PUBKEY_ADDRESS" => 60, "SECRET_KEY" => 188, "cli" => "komodo-cli"),
   // Array("name" => "GAME", "PUBKEY_ADDRESS" => 38, "SECRET_KEY" => 166, "cli" => "gamecredits-cli"),
    //Array("name" => "HUSH", "PUBKEY_ADDRESS" => Array(0x1C,0xB8), "SECRET_KEY" => 0x80, "cli" => "hush-cli"),
    //Array("name" => "HUSH",  "PUBKEY_ADDRESS" => 60, "SECRET_KEY" => 188, "cli" => "hush-cli"),
    Array("name" => "VRSC",  "PUBKEY_ADDRESS" => 60, "SECRET_KEY" => 188, "cli" => "verus"),
    Array("name" => "MCL",  "PUBKEY_ADDRESS" => 60, "SECRET_KEY" => 188, "cli" => "komodo-cli -ac_name=MCL"),
    Array("name" => "CHIPS",  "PUBKEY_ADDRESS" => 60, "SECRET_KEY" => 188, "cli" => "chips-cli"),
    Array("name" => "EMC2", "PUBKEY_ADDRESS" => 33, "SECRET_KEY" => 176, "cli" => "einsteinium-cli"),
   // Array("name" => "GIN", "PUBKEY_ADDRESS" => 38, "SECRET_KEY" => 198, "cli" => "gincoin-cli"),
    Array("name" => "AYA", "PUBKEY_ADDRESS" => 23, "SECRET_KEY" => 176, "cli" => "aryacoin-cli"),
    Array("name" => "GleecBTC", "PUBKEY_ADDRESS" => 35, "SECRET_KEY" => 65, "cli" => "gleecbtc-cli"),
    Array("name" => "SMARTUSD",  "PUBKEY_ADDRESS" => 60, "SECRET_KEY" => 188, "cli" => "smartusd-cli"),

);

$k = hash("sha256", $passphrase);
$k = pack("H*",$k);
$k[0] = Chr (Ord($k[0]) & 248); 
$k[31] = Chr (Ord($k[31]) & 127); 
$k[31] = Chr (Ord($k[31]) | 64);
$k = bin2hex($k);

$bitcoinECDSA->setPrivateKey($k);
echo "             Passphrase: '" . $passphrase . "'" . PHP_EOL;
echo PHP_EOL;




foreach ($coins as $coin) {
echo $coin["cli"] . " importprivkey " . $bitcoinECDSA->getWIF( true, $coin["SECRET_KEY"]) . PHP_EOL;
//$out = print_r($coin["cli"] . " importprivkey " . $bitcoinECDSA->getWIF( true, $coin["SECRET_KEY"]) . PHP_EOL);
//echo($coin["cli"] . " : " . $out . PHP_EOL);
}
