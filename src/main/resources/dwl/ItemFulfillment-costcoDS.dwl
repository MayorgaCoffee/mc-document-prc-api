output java ---
{
  "TransactionSets": {
    "v004010": {
      "856": [
        {
          "Heading": {
            "020_BSN": {
              "BSN01": "00",
              "BSN02": payload.tranId,
              "BSN03": "2024-02-01T00:00:00+05:30" as DateTime,
              "BSN04": 45180000,
              "BSN05": "0001",
            }
          },
          "SetTrailer": {
            "SE02": "0001",
            "SE01": 23
          },
          "Summary": {
            "010_CTT": {
              "CTT01": 1
            }
          },
          "Id": "856",
          "SetHeader": {
            "ST01": "856",
            "ST02": "0001"
          },
          "Detail": {
            "010_HL_Loop": [
              {
                "200_DTM": [
                  {
                    "DTM01": if (payload.shipStatus ~= "_shipped") "011" else "704",
                    "DTM02": payload.lastModifiedDate as DateTime
                  }
                ],
                "120_TD5": [
                  {
                    "TD501": "B",
                    "TD505": payload.customFieldList.custbodyhj_tc_udf2
                  }
                ],
                "150_REF": [
                  {
                    "REF01": "CP",
                    "REF02": payload.packageUpsList.packageUps.packageTrackingNumberUps
                  },
                  {
                    "REF01": "IA",
                    "REF02": "6746100"
                  }
                ],
                "010_HL": {
                  "HL01": "1",
                  "HL03": "S"
                },
                "220_N1_Loop": [
                  {
                    "220_N1": {
                      "N101": "ST",
                      "N102": payload.shippingAddress.addressee
                    },
                    "240_N3": [
                      {
                        "N301": payload.shippingAddress.addr1
                      }
                    ],
                    "250_N4": {
                      "N401": payload.shippingAddress.city,
                      "N402": payload.shippingAddress.state,
                      "N403": payload.shippingAddress.zip,
                      "N404": "US"
                    }
                  },
                  {
                    "220_N1": {
                      "N101": "SF",
                      "N102": "Mayorga Organics",
                      "N103": "93",
                      "N104": "ROCKVILLE WH"
                    }
                  }
                ],
                "110_TD1": [
                  {
                    "TD107": payload.itemList.item.customFieldList.custcol_if_bol_col_weight_item as Number,
                    "TD108": if (payload.itemList.item.customFieldList.custcol_bol_weight_units_show ~= "lb") "01" else "01" as Number,
                    "TD102": 25,
                    "TD101": "CTN"
                  }
                ]
              },
              {
                "010_HL": {
                  "HL01": "2",
                  "HL03": "O",
                  "HL02": "1"
                },
                "050_PRF": {
                  "PRF01": payload.customFieldList.custbodyhj_tc_fulfill_po
                }
              },
              {
                "190_MAN": [
                  {
                    "MAN01": "CP",
                    "MAN02": payload.packageUpsList.packageUps.packageTrackingNumberUps
                  }
                ],
                "010_HL": {
                  "HL01": "3",
                  "HL03": "P",
                  "HL02": "2"
                }
              },
              {
                "150_REF": [
                  {
                    "REF03": payload.itemList.item.customFieldList.custcol_cleo_vendor_part_number,
                    "REF01": "SE"
                  }
                ],
                "010_HL": {
                  "HL01": "4",
                  "HL03": "I",
                  "HL02": "3"
                },
                "030_SN1": {
                  "SN102": payload.itemList.item.quantity as Number,
                  "SN103": payload.itemList.item.unitsDisplay,
                  "SN108": if (payload.shipStatus ~= "_shipped") "AC" else "IB"
                },
                "020_LIN": {
                  "LIN02": "SK",
                  "LIN01": "1",
                  "LIN04": "VN",
                  "LIN03": payload.itemList.item.customFieldList.custcol_cleo_item_sku,
                  "LIN05": payload.itemList.item.customFieldList.custcol_cleo_vendor_part_number
                }
              }
            ]
          }
        }
      ]
    }
  }
}
