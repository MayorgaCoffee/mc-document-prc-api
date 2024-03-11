%dw 2.0
ns ns0 urn:messages.platform.webservices.netsuite.com
ns ns01 urn:sales.transactions.webservices.netsuite.com
ns ns02 urn:common.platform.webservices.netsuite.com
ns ns03 urn:core.platform.webservices.netsuite.com
var shippingAddress = flatten(payload.TransactionSets.v004010."850".Heading."310_N1_Loop")[0]
output application/xml  
---
{
  ns0#add: {
    ns0#record @('xmlns:ns01': ns01, xsi#'type': 'ns01:SalesOrder'): (payload.TransactionSets.v004010."850") map ((value, index) -> {
      ns01#entity @(internalId: "1147"): {
          name: "CostcoDepot"
      },
      ns01#tranDate: value.Heading."020_BEG".BEG05 as DateTime,
      ns01#otherRefNum: value.Heading."020_BEG".BEG03 default "",
      ns01#shippingAddress: {
        ns02#country: 
          if ((shippingAddress."340_N4".N404[0] default "") ~= "US")
            "_unitedStates"
          else
            "",
        ns02#addressee: shippingAddress."310_N1".N102 default "",
        ns02#addr1: shippingAddress."330_N3".N301[0] default "",
        ns02#city: shippingAddress."340_N4".N401[0] default "",
        ns02#state: shippingAddress."340_N4".N402[0] default "",
        ns02#zip: shippingAddress."340_N4".N403[0] default ""
      },
      ns01#shipDate: (value.Heading."150_DTM" filter (item) -> item.DTM01 == "010")."DTM02"[0] as DateTime default "",
      ns01#endDate: (value.Heading."150_DTM" filter (item) -> item.DTM01 == "002")."DTM02"[0] as DateTime default "",
      ns01#department @(internalId: p("$((value.Heading."050_REF" filter (item) -> item.REF01 == "19").REF02[0])")): {},
      ns01#itemList: {
        (value.Detail."010_PO1_Loop" map ((value1, index) -> {
          ns01#item: {
            ns01#item @(internalId: p('$(value1."010_PO1".PO107)')): {},
            ns01#quantity: value1."010_PO1".PO102 as Number,
            ns01#units: {
              name: value1."010_PO1".PO103 default ''
            },
            ns01#department @(internalId: p("$((value.Heading."050_REF" filter (item) -> item.REF01 == "19").REF02[0])")): {
              name: (value.Heading."050_REF" filter (item) -> item.REF01 == "19").REF03[0]
            },
            ns01#rate: value1."010_PO1".PO104 default "",
            ns01#line: value1."010_PO1".PO101 as Number default "",
            ns01#description: value1."050_PID_Loop"."050_PID".PID05[0] default ""
          }
        }))
      },
      ns01#customFieldList: {
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_trans_set_purpose_code"): {
          ns03#value: (value.Heading."020_BEG".BEG01 default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_po_type_code"): {
          ns03#value: value.Heading."020_BEG".BEG02 default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": " custbody_cleo_vendor_id_number"): {
          ns03#value: (value.Heading."050_REF" filter (item) -> item.REF01 == "VR").REF02[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbodyhj_tc_edideptno"): {
          ns03#value: (value.Heading."050_REF" filter (item) -> item.REF01 == "DP").REF02[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_buyer_identification"): {
          ns03#value: (value.Heading."050_REF" filter (item) -> item.REF01 == "YD").REF02[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_ship_method_of_payment"): {
          ns03#value: value.Heading."080_FOB".FOB01[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_fob_location_qualifier"): {
          ns03#value: value.Heading."080_FOB".FOB02[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_fob_description"): {
          ns03#value: value.Heading."080_FOB".FOB03[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_terms_type_code"): {
          ns03#value: (value.Heading."130_ITD".ITD01[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_terms_basis_date_code"): {
          ns03#value: (value.Heading."130_ITD".ITD02[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_term_discount_percentage"): {
          ns03#value: (value.Heading."130_ITD".ITD03[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_terms_discount_days_due"): {
          ns03#value: (value.Heading."130_ITD".ITD05[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:LongCustomFieldRef", "scriptId": "custbody_cleo_terms_net_days"): {
          ns03#value: (value.Heading."130_ITD".ITD07[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_terms_description"): {
          ns03#value: (value.Heading."130_ITD".ITD12[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbodymsgso"): {
          ns03#value: (value.Heading."295_N9_Loop" filter (item) -> item."295_N9"."N901" == "H7")."300_MSG".."MSG01" joinBy " " default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_legal_notes"): {
          ns03#value: (value.Heading."295_N9_Loop" filter (item) -> item."295_N9"."N901" == "H5")."300_MSG".."MSG01" joinBy " " default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_st_locationcodequalifier"): {
          ns03#value: value.Heading."310_N1_Loop"."310_N1".N103[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_st_addresslocationnumber
        "): {
          ns03#value: value.Heading."310_N1_Loop"."310_N1".N104[0] default ""
        }
      }
    })
  }
}