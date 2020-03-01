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
class OverView{
    public $concertId;
    public $spending;
    public $earning;
    public $profit;
    public $totalTickets;
    public $soldTickets;
    public $voucherTickets;
    function __construct($concertId,$spending,$earning,$profit,$totalTickets,$soldTickets,$voucherTickets){
        $this->concertId = $concertId;
        $this->spending = $spending;
        $this->earning = $earning;
        $this->profit = $profit;
        $this->totalTickets = $totalTickets;
        $this->soldTickets = $soldTickets;
        $this->voucherTickets = $voucherTickets;
    }
}
class Option{
    public $id;
    public $value;
    function __construct($id,$value){
        $this->id = $id;
        $this->value= $value;
        
    }
}
class ActiveSta{
    public $months;
    public $values;
    function __construct($months,$values){
        $this->months = $months;
        $this->values= $values;
    }
}
class BestSta{
    public $artists;
    public $sold;
    function __construct($artists,$sold){
        $this->artists = $artists;
        $this->sold= $sold;
    }
}
class SoldSta{
    public $date;
    public $income;
    public $tickets;
    function __construct($date,$income,$tickets){
        $this->date = $date;
        $this->income= $income;
        $this->tickets= $tickets;
    }
}
?>