import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/components/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/models/resto.dart'; // Add your resto model import
import 'package:intl/intl.dart';
import 'package:uasppb_2021130007/pages/order_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = '';
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  void pay() {
    if (_selectedPayment == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tolong pilih metode pembayaran'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    } else {
      Provider.of<Resto>(context, listen: false)
          .setCustomerName(_nameController.text);
      if (formKey.currentState!.validate()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Konfirmasi Pembayaran"),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nama : ${_nameController.text}"),
                  Text("Pembayaran: $_selectedPayment"),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OrderPage(),
                    ),
                  );
                },
                child: const Text("Pay"),
              ),
            ],
          ),
        );
      }
    }
    // Navigate to the next screen or perform payment processing here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tolong isi nama anda';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Payment Method:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                RadioListTile(
                  title: const Text('Cash'),
                  value: 'Cash',
                  groupValue: _selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      _selectedPayment = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Bank Transfer'),
                  value: 'Transfer Bank',
                  groupValue: _selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      _selectedPayment = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('QRIS'),
                  value: 'Qris',
                  groupValue: _selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      _selectedPayment = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Total Price:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(Provider.of<Resto>(context).getTotalPrice()),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Konfirmasi Pembayaran",
                  onTap: pay,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
