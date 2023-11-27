({
    init : function(c, e, h) {
        let newPromise = new Promise((resolve, reject)=>{
            h.getRPL(c,e,h, resolve, reject);
        });
        newPromise.then(()=>{
            h.showAnnualy(c, e, h);
        })
        
    },
    selectType: function(c,e,h){
        let selectTag = document.querySelector("#timeType");
        let quarterSelectDiv = document.querySelector(".quarter-select-div");
        let monthSelectDiv = document.querySelector(".month-select-div");
        if(selectTag.value == 'annualy'){
            h.showAnnualy(c, e, h);
            quarterSelectDiv.classList.add("hide");
            monthSelectDiv.classList.add("hide");
        } else if(selectTag.value == 'quarterly'){
            monthSelectDiv.classList.add("hide");
            quarterSelectDiv.classList.remove("hide");
            let selectQuarterTag = document.querySelector("#quarter-select");
            h.showQuarterly(c, e, h, selectQuarterTag.value);
        } else if(selectTag.value == 'monthly'){
            quarterSelectDiv.classList.add("hide");
            monthSelectDiv.classList.remove("hide");
            let selectMonthTag = document.querySelector("#month-select");
            h.showMonthly(c, e, h, selectMonthTag.value);
        }
    },
    selectMonth: function(c,e,h){
        let selectTag = document.querySelector("#month-select");
        h.showMonthly(c, e, h, selectTag.value);
    },
    selectQuarter: function(c,e,h){
        let selectTag = document.querySelector("#quarter-select");
        h.showQuarterly(c, e, h, selectTag.value);
    }
})