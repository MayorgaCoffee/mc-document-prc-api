%dw 2.0
import * from dw::core::Strings
output application/java
fun convertToDateTime(date) = (
        (substring(date, 0, 4)) ++ "-" ++ 
        (substring(date, 4, 6)) ++ "-" ++ 
        (substring(date, 6, 8)) ++ "T00:00:00"
    ) as DateTime

fun roundDown(n) = do {
    var power = 10 pow 3
    ---
    if (n>0) floor(n * power)/power
    else ceil(n * power)/power
}
---
  "TransactionSets": {
    "v004010": {
      "810": [
        {
          "Heading": {
            "020_BIG": {
              "BIG04": payload.otherRefNum,
              "BIG01": payload.tranDate as DateTime,
              "BIG02": payload.tranId,
              "BIG03": convertToDateTime(payload.customFieldList.custbodyhj_tc_udf5)
            },
            "130_ITD": [
              {
                "ITD02": "2", //No mapping
                "ITD01": "01", //has to be hardcoded
                "ITD12": payload.terms.name,
                "ITD06": payload.dueDate as DateTime,
                "ITD05": 20,
                "ITD04": payload.discountDate as DateTime,
                "ITD03": 1, //has to be hardcoded
                "ITD07": 25 //has to be harcoded
              }
            ],
            "070_N1_Loop": [
              {
                "100_N4": {
                  "N401": payload.shippingAddress.city,
                  "N402":  payload.shippingAddress.state,
                  "N403":  payload.shippingAddress.zip,
                  "N404": if (payload.shippingAddress.country ~= "_unitedStates") "US" else ""
                },
                "090_N3": [
                  {
                    "N301": payload.shippingAddress.addr1
                  }
                ],
                "070_N1": {
                  "N101": "ST", //has to be hardcoded
                  "N102": payload.shippingAddress.addressee,
                  "N103": "9", //has to be hardcoded
                  "N104": payload.customFieldList.custbodyhj_tc_storecode
                }
              }
            ]
          },
          "Summary": {
            "010_TDS": {
              "TDS01": roundDown(payload.total)
            },
            "070_CTT": {
              "CTT01": 1
            }
          },
          "Detail": {
            "010_IT1_Loop": [
              {
                "180_SAC_Loop": [
                  {
                    "180_SAC": {
                      "SAC01": "A", //has to be hardcoded
                      "SAC12": "02", //has to be harcoded
                      "SAC02": "ZZZZ", //has to be hardcoded
                      "SAC15": "Spoilage- 1%", //has to be hardcoded
                      "SAC05": roundDown(payload.subTotal)
                    }
                  }
                ],
                "060_PID_Loop": [
                  {
                    "060_PID": {
                      "PID01": "F", //has to be hardcoded
                      "PID05": payload.itemList.item.description
                    }
                  }
                ],
                "010_IT1": {
                  "IT104": payload.itemList.item.rate as Number,
                  "IT103": payload.itemList.item.units.name,
                  "IT102": payload.itemList.item.quantity as Number,
                  "IT109": payload.itemList.item.item.name,
                  "IT108": "VN", //has to be hardcoded
                  "IT107": payload.itemList.item.customFieldList.custcol_tp_item_number,
                  "IT106": "IN", //has to be hardcoded
                  "IT111": payload.itemList.item.item.name,
                  "IT110": "VP" //has to be hardcoded
                }
              }
            ]
          },
          "Name": "Invoice"
        }
      ]
    }
  }