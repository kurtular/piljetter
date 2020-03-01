<div id="STATISTIC">
    <div id="sold-tickets">
        <h1>Antal sålda biljetter och total försäljningsintäkt.</h1>
        <div>
            <div>
                <label >från och med</label><br>
                <input type="date" id="from-sold-date" required onchange="updateSta('update')" value="<?php echo date('Y-m-d',strtotime("-365 days"));?>">
            </div>
            <div>
                <label >till och med</label><br>
                <input type="date" id="to-sold-date" required onchange="updateSta('update')" value="<?php echo date('Y-m-d');?>" onchange="showSta('sold')">
            </div>
        </div>
        <div id="sold-tickets-sta"><canvas></canvas></div>
    </div>
    <div id="ten-best-artists">
        <h1>De bästa säljande artisterna.(tio artister max)</h1>
        <div>
            <div>
                <label >från och med</label><br>
                <input type="date" id="from-best-date" required onchange="updateSta('update')" value="<?php echo date('Y-m-d',strtotime("-365 days"));?>">
            </div>
            <div>
                <label >till och med</label><br>
                <input type="date" id="to-best-date" required onchange="updateSta('update')" value="<?php echo date('Y-m-d');?>">
            </div>
        </div>
        <div id="ten-best-artists-sta"><canvas></canvas></div>
    </div>
    <div id="active-vouchers">
        <h1>Översikt över utgivna kuponger.</h1>
        <div>
            <div>
                <label >från och med</label><br>
                <input type="month" id="from-active-date" required onchange="updateSta('update')" value="<?php echo date('Y-m');?>">
            </div>
            <div>
                <label >till och med</label><br>
                <input type="month" id="to-active-date" required onchange="updateSta('update')" value="<?php echo date('Y-m',strtotime("+365 days"));?>">
            </div>
        </div>
        <div id="active-vouchers-sta"><canvas></canvas></div>
    </div>
</div>