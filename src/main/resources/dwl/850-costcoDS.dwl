%dw 2.0
var shippingAddress = flatten(payload.TransactionSets.v004010."850".Heading."310_N1_Loop")[0]
ns ns0 urn:messages.platform.webservices.netsuite.com
ns ns01 urn:sales.transactions.webservices.netsuite.com
ns ns02 urn:common.platform.webservices.netsuite.com
ns ns03 urn:core.platform.webservices.netsuite.com
output application/xml
---
{
  ns0#add: {
    ns0#record @('xmlns:ns01': ns01, xsi#'type': 'ns01:SalesOrder'): (payload.TransactionSets.v004010."850") map ((value, index) -> {
      ns01#entity @(internalId: "1328"): "CostcoDS",
      ns01#tranDate: value.Heading."020_BEG".BEG05 as DateTime,
      ns01#otherRefNum: value.Heading."020_BEG".BEG03 default "",
      ns01#shippingAddress: {
        ns02#country: if((shippingAddress."340_N4".N404[0] default "") ~= "US") "_unitedStates" else "",
        ns02#addressee: shippingAddress."310_N1".N102 default "",
        ns02#addr1: shippingAddress."330_N3".N301 default "",
        ns02#city: shippingAddress."340_N4".N401 default "",
        ns02#state: shippingAddress."340_N4".N402 default "",
        ns02#zip: shippingAddress."340_N4".N403 default "",
        ns02#addrPhone: shippingAddress."360_PER".PER04[0] default ""
      },
      ns01#shipDate: (value.Heading."150_DTM" filter (item) -> item.DTM01 == "004")."DTM02"[0] as DateTime default "",
      ns01#endDate: (value.Heading."150_DTM" filter (item) -> item.DTM01 == "006")."DTM02"[0] as DateTime default "",
      ns01#shipMethod @(internalId: "16"): value.Heading."240_TD5".TD505[0] default '',
      ns01#department @(internalId: "26"): {},
      ns01#itemList: {
        ns01#item: (value.Detail mapObject ((value, index) -> {
        	ns01#item @(internalId: "1483"): {},
            ns01#quantity: value."010_PO1".PO102[0] as Number,
            ns01#units: {
              name: value."010_PO1".PO103[0] default ''
            },
            ns01#rate: value."010_PO1".PO104[0] default "",
            ns01#line: value."010_PO1".PO101[0] as Number default "",
            ns01#customFieldList: {
              ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custcol_cleo_item_sku"): {
               ns03#value: (value."010_PO1".PO107[0] default "")
              },
              ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custcol_cleo_vendor_part_number"): {
               ns03#value: value."010_PO1".PO109[0] default ""
              },
              ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custcol_cleo_edi_prod_desc"): {
               ns03#value: value."050_PID_Loop"[0]."050_PID".PID05[0] default ""
              }
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
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_internal_vendor_number"): {
         ns03#value: (value.Heading."050_REF" filter (item) -> item.REF01 == "IA").REF02[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_cust_order_no"): {
         ns03#value: (value.Heading."050_REF" filter (item) -> item.REF01 == "CO").REF02[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_carrier_routing"): {
         ns03#value: (value.Heading."240_TD5".TD505[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbodyhj_tc_udf2"): {
         ns03#value: (value.Heading."240_TD5".TD505[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_legal_notes"): {
          ns03#value: (value.Heading."295_N9_Loop"."295_N9".N902[0] default "")
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_st_locationcodequalifier"): {
          ns03#value: value.Heading."310_N1_Loop"."310_N1".N103[0] default ""
        },
        ns03#customField @("xsi:type": "ns03:StringCustomFieldRef", "scriptId": "custbody_cleo_st_addresslocationnumber"): {
          ns03#value: value.Heading."310_N1_Loop"."310_N1".N104[0] default ""
        }
      }
    })
  }}
