import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'billItem.dart';

final menuItemColRef = Firestore.instance.collection('MenuItems');
final billColRef = Firestore.instance.collection('BillList');

class Billing extends StatefulWidget {
  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  String type;
  LocalKey k;
  bool sel = false;
  bool loading = false;
  TextEditingController customer = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController itemName = TextEditingController();
  TextEditingController quantity = TextEditingController();
  String cashier = 'Example name';
  bool load = false;
  int srl = 1;
  int billno = 0;
  List<DropdownMenuItem> getItems = [];
  List itemList = [];
  List srlno = [];
  List<BillItem> billitemlist = [];
  List<BillItem> selectedbillitemlist = [];
  List<int> quant = [];
  List priceunit = [];
  List amount = [];
  List<DataRow> rowList = [];

  double itemsum = 0;
  double packing = 0;
  double gstper = 0;
  double gstCharge = 0.0;
  double grandtot = 0.0;

  additemtotal() {
    itemsum = 0;
    gstCharge = 0.0;
    grandtot = 0.0;
    // setState(() {
    //   itemsum += val;
    //   gstCharge = itemsum * gstper * 0.01;
    //   grandtot = gstCharge + itemsum;
    // });
    setState(() {
      billitemlist.forEach((element) {
        itemsum += element.amount;
      });
      gstCharge = itemsum * gstper * 0.01;
      grandtot = gstCharge + itemsum;
    });
  }

  @override
  void initState() {
    super.initState();
    menuItemColRef.getDocuments().then((value) {
      value.documents.forEach((element) {
        getItems.add(DropdownMenuItem(
          child: Text(element.data['Item_Name']),
          value: element.data['Item_Name'].toString(),
        ));
      });
    });
    billColRef.document('info').get().then(
      (value) {
        setState(() {
          billno = value.data['takeid'];
        });
      },
    );
  }

  packDrop() {
    return DropdownButton(
      value: packing,
      hint: Text('Packing Charge'),
      items: [
        DropdownMenuItem(
          child: Text('packing: 0'),
          value: 0,
        ),
        DropdownMenuItem(
          child: Text('packing: 5'),
          value: 5,
        ),
        DropdownMenuItem(
          child: Text('packing: 10'),
          value: 10,
        ),
        DropdownMenuItem(
          child: Text('packing: 15'),
          value: 15,
        ),
        DropdownMenuItem(
          child: Text('packing: 20'),
          value: 20,
        )
      ],
      onChanged: (value) {
        setState(() {
          packing = value;
        });
      },
    );
  }

  List<DropdownMenuItem> gstList = List.generate(
      25,
      (index) => DropdownMenuItem(
            child: Text('GST ' + index.toString() + " %"),
            value: index,
          ));
  gstDrop() {
    return DropdownButton(
      value: gstper,
      hint: Text('Gst percentage'),
      items: gstList,
      onChanged: (value) {
        setState(() {
          gstper = value;
        });
      },
    );
  }

  onselectedRow(bool selected, BillItem billitem) async {
    setState(() {
      if (selected) {
        selectedbillitemlist.add(billitem);
      } else {
        selectedbillitemlist.remove(billitem);
      }
    });
  }

  deleteItems() async {
    setState(() {
      if (selectedbillitemlist.isNotEmpty) {
        List<BillItem> temp = [];
        temp.addAll(selectedbillitemlist);
        for (BillItem item in temp) {
          billitemlist.remove(item);
          selectedbillitemlist.remove(item);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/dashboard.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black38),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 100,
              right: 100,
              top: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: 175,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Invoice',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 2,
                              endIndent: 20,
                              indent: 10,
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        child: DigitalClock(
                          areaDecoration:
                              BoxDecoration(color: Colors.transparent),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 210,
                          width: double.infinity,
                          color: Color.fromRGBO(206, 206, 206, 1),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'assets/minilogo.png',
                                      fit: BoxFit.cover,
                                      height: 100,
                                    ),
                                    packDrop(),
                                    gstDrop(),
                                    Icon(Icons.receipt, size: 100)
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Near SBI ATM Godhna Road Ara, Bhojpur,\nPhone Number - 9852259112, 8340245998',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Container(
                                      // height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white,
                                      ),
                                      width: 400,
                                      // alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SearchableDropdown.single(
                                          items: getItems,
                                          value: itemName,
                                          hint: 'Search',
                                          searchHint: 'search',
                                          onChanged: (value) {
                                            print(value);
                                            setState(() {
                                              itemName.text = value;
                                            });
                                          },
                                          isExpanded: true,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      width: 200,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        controller: quantity,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          focusColor: Colors.white,
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: 'Quantity',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        setState(() {
                                          loading = true;
                                        });
                                        menuItemColRef
                                            .where("Item_Name",
                                                isEqualTo: itemName.text)
                                            .getDocuments()
                                            .then(
                                          (querySnapshot) {
                                            if (querySnapshot
                                                    .documents.length !=
                                                0) {
                                              querySnapshot.documents.forEach(
                                                (result) {
                                                  billitemlist.add(BillItem(
                                                      name: result
                                                          .data['Item_Name'],
                                                      price: int.parse(
                                                          result.data['Price']),
                                                      quantity: int.parse(
                                                          quantity.text),
                                                      amount: int.parse(
                                                              quantity.text) *
                                                          int.parse(result
                                                              .data['Price'])));
                                                  setState(() {});
                                                  additemtotal();
                                                },
                                              );
                                              setState(
                                                () {
                                                  srl++;
                                                },
                                              );
                                            }
                                          },
                                        ).whenComplete(
                                          () {
                                            setState(
                                              () {
                                                loading = false;
                                                quantity.clear();
                                                itemName.clear();
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Add',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      color: Colors.orange,
                                      padding: EdgeInsets.all(12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    loading
                                        ? CircularProgressIndicator()
                                        : Container(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                alignment: Alignment.topCenter,
                                padding: const EdgeInsets.all(50.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      elevation: 5,
                                      child: Container(
                                        color: Colors.white,
                                        child: DataTable(
                                          columns: <DataColumn>[
                                            DataColumn(
                                              label: Text(
                                                'Item',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Unit Price',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Quantity',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Amount',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                          rows: billitemlist
                                              .map(
                                                (billitem) => DataRow(
                                                  onSelectChanged: (selected) {
                                                    onselectedRow(
                                                        selected, billitem);
                                                  },
                                                  selected: selectedbillitemlist
                                                      .contains(billitem),
                                                  cells: [
                                                    // DataCell(Text(billitem.srlNo
                                                    //     .toString())),
                                                    DataCell(Text(billitem.name
                                                        .toString())),
                                                    DataCell(Text(billitem.price
                                                        .toString())),
                                                    DataCell(Text(billitem
                                                        .quantity
                                                        .toString())),
                                                    DataCell(Text(billitem
                                                        .amount
                                                        .toString())),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      elevation: 5,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 400,
                                            alignment: Alignment.center,
                                            color: Colors.orange[400],
                                            child: Text(
                                              'Total Amount',
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            height: 300,
                                            width: 350,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading: Text('Item Total'),
                                                  trailing: Text('Rs ' +
                                                      itemsum.toString()),
                                                ),
                                                ListTile(
                                                  leading: Text('Packaging'),
                                                  trailing: Text('Rs ' +
                                                      packing.toString()),
                                                ),
                                                ListTile(
                                                  leading: Text('GST @ ' +
                                                      gstper.toString()),
                                                  trailing: Text('Rs ' +
                                                      gstCharge
                                                          .toStringAsFixed(2)),
                                                ),
                                                ListTile(
                                                  leading: Text('Grand Total'),
                                                  trailing: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    child: Text('Rs ' +
                                                        (packing + grandtot)
                                                            .toStringAsFixed(
                                                                2)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                      onPressed: selectedbillitemlist.isEmpty
                                          ? null
                                          : () {
                                              deleteItems();
                                              additemtotal();
                                            },
                                      child: Text(
                                        'Delete Item',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      color: Colors.orange,
                                      padding: EdgeInsets.all(18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      width: 250,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        controller: customer,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          focusColor: Colors.white,
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: 'Customer Name',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 100,
                                      width: 250,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        controller: phoneNo,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone),
                                          focusColor: Colors.white,
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: 'Phone Number',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      padding: EdgeInsets.all(8),
                                      width: 200,
                                      alignment: Alignment.center,
                                      child: DropdownButton(
                                        value: type,
                                        focusColor: Colors.white,
                                        hint: Text('Payment Type'),
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('Cash'),
                                            value: 'Cash',
                                          ),
                                          // DropdownMenuItem(
                                          //   child: Text('UPI'),
                                          //   value: 'UPI',
                                          // ),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            type = value;
                                          });
                                        },
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        setState(() {
                                          load = true;
                                        });
                                        load
                                            ? showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18)),
                                                  title: Text('Proccesing'),
                                                  content: Container(
                                                    height: 100,
                                                    width: 100,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12.0,
                                                          vertical: 35),
                                                      child:
                                                          LinearProgressIndicator(),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Text('');
                                        for (int i = 0;
                                            i < billitemlist.length;
                                            i++) {
                                          srlno.add(i + 1);
                                          itemList.add(billitemlist[i].name);
                                          quant.add(billitemlist[i].quantity);
                                          priceunit.add(billitemlist[i].price);
                                          amount.add(billitemlist[i].amount);
                                        }

                                        String date = DateFormat('dd-MM-yyy')
                                            .format(DateTime.now());
                                        print(date);
                                        http.Response response =
                                            await http.post(
                                          'https://jsontopdfconverter.herokuapp.com/getPdf',
                                          headers: <String, String>{
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                          body: jsonEncode(
                                            <String, dynamic>{
                                              "bill_no": billno,
                                              "bill_to": customer.text,
                                              "mob_no": phoneNo.text,
                                              "sno": srlno,
                                              "item": itemList,
                                              "qty": quant,
                                              "priceu": priceunit,
                                              "gst": [],
                                              "amount": amount,
                                              "total_qty": quant.reduce(
                                                  (value, element) =>
                                                      value + element),
                                              "total_gst": 50,
                                              "total_amt": itemsum,
                                              "subtotal": itemsum + packing,
                                              "cgst": (gstCharge / 2)
                                                  .toStringAsFixed(2),
                                              "sgst": (gstCharge / 2)
                                                  .toStringAsFixed(2),
                                              "date": date,
                                              "total": grandtot + packing,
                                            },
                                          ),
                                        );
                                        print(response.statusCode);
                                        billColRef
                                            .document(billno.toString())
                                            .setData({
                                          "bill_no": billno.toString(),
                                          "bill_to": customer.text.toString(),
                                          "mob_no": phoneNo.text.toString(),
                                          "sno": srlno,
                                          "item": itemList,
                                          "qty": quant,
                                          "priceu": priceunit,
                                          "amount": amount,
                                          "total_qty": quant.reduce(
                                              (value, element) =>
                                                  value + element),
                                          "total_amt": itemsum,
                                          "subtotal": itemsum + packing,
                                          "cgst": (gstCharge / 2)
                                              .toStringAsFixed(2),
                                          "sgst": (gstCharge / 2)
                                              .toStringAsFixed(2),
                                          "date": DateTime.now(),
                                          "total": grandtot + packing,
                                        });
                                        await Printing.layoutPdf(
                                            onLayout: (_) =>
                                                response.bodyBytes);
                                        setState(() {
                                          srl = 1;
                                          load = false;
                                        });
                                        Navigator.of(context).pop();
                                        billno++;
                                        billColRef.document('info').updateData({
                                          "takeid": billno,
                                        });
                                        print('new' + billno.toString());                                        
                                        billitemlist.clear();                                        
                                        itemList.clear();
                                        customer.clear();
                                        phoneNo.clear();
                                        srlno.clear();
                                        selectedbillitemlist.clear();
                                        quant.clear();
                                        priceunit.clear();
                                        amount.clear();
                                        rowList.clear();
                                      },
                                      child: Text(
                                        'Print Bill',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      color: Colors.orange,
                                      padding: EdgeInsets.all(18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
