<?php
class concert{
    public $concertId;
    public $artistName;
    public $sceneName;
    public $address;
    public $city;
    public $date;
    public $time;
    public $ticketPrice;
    public $remainingTickets;
    function __construct($concertId,$artistName,$sceneName,$address,$city,$date,$time,$ticketPrice,$remainingTickets){
        $this->concertId = $concertId;
        $this->artistName = $artistName;
        $this->sceneName = $sceneName;
        $this->address = $address;
        $this->city = $city;
        $this->date = $date;
        $this->time = $time;
        $this->ticketPrice = $ticketPrice;
        $this->remainingTickets = $remainingTickets;
    }
}
class AdminConcert{
    public $concertId;
    public $artistName;
    public $sceneName;
    public $address;
    public $city;
    public $date;
    public $time;
    public $ticketPrice;
    public $remainingTickets;
    public $cancelled;
    function __construct($concertId,$artistName,$sceneName,$address,$city,$date,$time,$ticketPrice,$remainingTickets,$cancelled,$passed){
        $this->concertId = $concertId;
        $this->artistName = $artistName;
        $this->sceneName = $sceneName;
        $this->address = $address;
        $this->city = $city;
        $this->date = $date;
        $this->time = $time;
        $this->ticketPrice = $ticketPrice;
        $this->remainingTickets = $remainingTickets;
        $this->cancelled = $cancelled;
        $this->passed = $passed;
    }
}
class user{
    public $name;
    public $balance;
    function __construct($name,$balance){
        $this->name=$name;
        $this->balance=$balance;
    }
}
class ticket{
    public $ticketId;
    public $artistName;
    public $sceneName;
    public $city;
    public $country;
    public $date;
    public $time;
    public $ticketPrice;
    public $purchaseDate;
    public $vouchered;
    function __construct($ticketId,$artistName,$sceneName,$city,$country,$date,$time,$ticketPrice,$purchaseDate,$vouchered){
        $this->ticketId = $ticketId;
        $this->artistName = $artistName;
        $this->sceneName = $sceneName;
        $this->city = $city;
        $this->country = $country;
        $this->date = $date;
        $this->time = $time;
        $this->ticketPrice = $ticketPrice;
        $this->purchaseDate = $purchaseDate;
        $this->vouchered = $vouchered;
    }
}
class voucher{
    public $voucherId;
    public $issuedDate;
    public $expiryDate;
    public $used;
    function __construct($voucherId,$issuedDate,$expiryDate,$used){
        $this->voucherId = $voucherId;
        $this->issuedDate = $issuedDate;
        $this->expiryDate = $expiryDate;
        $this->used= $used;
        
    }
}
?>