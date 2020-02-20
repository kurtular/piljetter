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
?>