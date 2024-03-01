%dw 2.0
output application/json  
---
payload.TransactionSets.v004010."850" map ((value, index) -> {
  tranDate: value.Heading."020_BEG".BEG05,
  otherRefNum: value.Heading."020_BEG".BEG03 default "",
  shippingAddress: ((value.Heading."310_N1_Loop") map {
    country: $."340_N4".N404[0] default "",
    addressee: $."310_N1".N102 default "",
    addr1: $."330_N3".N301[0] default "",
    city: $."340_N4".N401[0] default "",
    state: $."340_N4".N402[0] default "",
    zip: $."340_N4".N403[0] default "",
    addrPhone: $."360_PER".PER04[0] default ""
  }),
  shipDate:  (value.Heading."150_DTM" filter (item) -> item.DTM01 == "004")."DTM02"[0] default "",
  endDate:  (value.Heading."150_DTM" filter (item) -> item.DTM01 == "006")."DTM02"[0] default "",
  shipMethod: value.Heading."240_TD5".TD505[0]  default  '',
  department: {
    "@internalId": null,
    "__text": null
  },
  itemList: {
    item: (value.Detail mapObject ((value, index) -> {
      item: {
        quantity: value."010_PO1".PO102[0] default '',
        units: {
          name: value."010_PO1".PO103[0] default ''
        },
        rate: value."010_PO1".PO104[0] default "",
        line: value."010_PO1".PO101[0] default "",
        customFieldList: {
          customField: {
            "@type": "StringCustomFieldRef",
            "@scriptId": "custcol_cleo_item_sku",
            value: (value."010_PO1".PO107[0] default "")
          },
          customField: {
            "@type": "StringCustomFieldRef",
            "@scriptId": "custcol_cleo_vendor_part_number",
            value: value."010_PO1".PO109[0] default ""
          },
          customField: {
            "@type": "StringCustomFieldRef",
            "@scriptId": "custcol_cleo_edi_prod_desc",
            value: value."050_PID_Loop"[0]."050_PID".PID05[0] default ""
          }
        }
      }
    }))
  },
  customFieldList: {
    customField: {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbody_cleo_trans_set_purpose_code",
      value: (value.Heading."020_BEG".BEG01 default "")
    },
    customField: {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbody_cleo_po_type_code",
      value: value.Heading."020_BEG".BEG02 default ""
    },
    customField: {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbody_cleo_internal_vendor_number",
      value: (value.Heading."050_REF" filter (item) -> item.REF01 == "IA").REF02[0] default ""
    },
    customField: {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbody_cleo_cust_order_no",
      value: (value.Heading."050_REF" filter (item) -> item.REF01 == "CO").REF02[0] default ""
    },
    customField: {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbody_cleo_carrier_routing",
      value: (value.Heading."240_TD5".TD505[0] default "")
    },
    customField: {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbodyhj_tc_udf2",
      value: (value.Heading."240_TD5".TD505[0] default "")
    },
    "customField": {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbody_cleo_legal_notes",
      "value": (value.Heading."295_N9_Loop"."295_N9".N902[0] default "")
    },
    "customField": {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbody_cleo_st_locationcodequalifier",
      "value": value.Heading."310_N1_Loop"."310_N1".N103[0] default ""
    },
    "customField": {
      "@type": "StringCustomFieldRef",
      "@scriptId": "custbody_cleo_st_addresslocationnumber",
      "value": value.Heading."310_N1_Loop"."310_N1".N104[0] default ""
    },
  }
})
// value.Detail  
// 	record: {
// 		"@type": null,
// 		tranDate: value.Heading."020_BEG".BEG05 as String default "",
// 		otherRefNum: value.Heading."020_BEG".BEG03[0] default "",
// 		shippingAddress: {
// 			country: value.Heading."310_N1_Loop"."340_N4".N404 default "",
// 			addressee: value.Heading."310_N1_Loop"."340_N4".N403 default "",
// 			addr1: value.Heading."310_N1_Loop"."330_N3".N301 default "",
// 			city: value.Heading."310_N1_Loop"."340_N4".N401 default "",
// 			state: value.Heading."310_N1_Loop"."340_N4".N402 default "",
// 			zip: value.Heading."310_N1_Loop"."340_N4".N403 default ""
// 		},
// 		shipMethod: {
// 			"@internalId": null,
// 			"__text": null
// 		},
// 		department: {
// 			"@internalId": null,
// 			"__text": null
// 		},
// 		itemList: {
// 			item: {
// 				quantity: value.Detail."010_PO1_Loop"."010_PO1".PO102 as String default "",
// 				units: {
// 					name: value.Detail."010_PO1_Loop"."010_PO1".PO103 default ""
// 				},
// 				rate: value.Detail."010_PO1_Loop"."010_PO1".PO104 as String default "",
// 				line: value.Detail."010_PO1_Loop"."010_PO1".PO101 default "",
// 				customFieldList: {
// 					customField: {
// 						"@type": "StringCustomFieldRef",
// 						"@scriptId": "custcol_cleo_item_sku",
// 						value: (value.Detail."010_PO1_Loop"."010_PO1".PO107 default "")
// 					},
// 					customField: {
// 						"@type": "StringCustomFieldRef",
// 						"@scriptId": "custcol_cleo_vendor_part_number",
// 						value: value.Detail."010_PO1_Loop"."010_PO1".PO109 default ""
// 					},
// 					customField: {
// 						"@type": "StringCustomFieldRef",
// 						"@scriptId": "custcol_cleo_edi_prod_desc",
// 						value: value.Detail."010_PO1_Loop"."050_PID_Loop"."050_PID".PID05 default ""
// 					}
// 				}
// 			}
// 		},
// 		customFieldList: {
// 			customField: {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbody_cleo_trans_set_purpose_code",
// 				value: (value.Heading."020_BEG".BEG01 default "")
// 			},
// 			customField: {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbody_cleo_po_type_code",
// 				value: value.Heading."020_BEG".BEG02 default ""
// 			},
// 			customField: {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbody_cleo_internal_vendor_number",
// 				value: (value.Heading."050_REF".REF02 default "")
// 			},
// 			customField: {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbody_cleo_cust_order_no",
// 				value: (value.Heading."050_REF".REF02 default "")
// 			},
// 			customField: {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbody_cleo_carrier_routing",
// 				value: (value.Heading."240_TD5".TD505 default "")
// 			},
// 			customField: {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbodyhj_tc_udf2",
// 				value: (value.Detail."010_PO1_Loop"."250_TD5".TD505 default "")
// 			},
// 			"customField": {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbody_cleo_legal_notes",
// 				"value": (value.Heading."295_N9_Loop"."295_N9".N902 default "")
// 			},
// 			"customField": {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbody_cleo_st_locationcodequalifier",
// 				"value": value.Heading."310_N1_Loop"."310_N1".N103 default ""
// 			},
// 			"customField": {
// 				"@type": "StringCustomFieldRef",
// 				"@scriptId": "custbody_cleo_st_addresslocationnumber",
// 				"value": value.Heading."310_N1_Loop"."310_N1".N104 default ""
// 			}
// 		}
// 	}
// }