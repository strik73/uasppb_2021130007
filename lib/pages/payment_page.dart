import 'package:flutter/material.dart';
import 'package:uasppb_2021130007/components/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:uasppb_2021130007/models/resto.dart'; // Add your resto model import

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPayment = 'cash';

  void pay() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Payment confirmed with ${_selectedPayment.toUpperCase()}'),
      ),
    );
    Navigator.pop(context);
    Provider.of<Resto>(context, listen: false).clearCart();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RadioListTile(
              title: const Text('Cash'),
              value: 'cash',
              groupValue: _selectedPayment,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text('Bank Transfer'),
              value: 'transfer',
              groupValue: _selectedPayment,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text('QRIS'),
              value: 'qris',
              groupValue: _selectedPayment,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value.toString();
                });
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Konfirmasi Pembayaran",
              onTap: pay,
            )
          ],
        ),
      ),
    );
  }
}
