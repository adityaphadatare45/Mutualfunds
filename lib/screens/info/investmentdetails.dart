import 'package:flutter/material.dart';
import 'package:mobileOs/screens/home.dart';

class Investmentdetails extends StatefulWidget {
  const Investmentdetails({super.key});

  @override
  State<StatefulWidget> createState() => _InvestmentPage();
}

class _InvestmentPage extends State<Investmentdetails> {
  final _formKey = GlobalKey<FormState>();

  // State variables for dropdowns and text fields
  String? _plantype;
  String? _schemeCategory;
  String? _investmentType;
  String? _holdingType;
  String? _physicalCopy;
  String? _paymentMode;
  String? _bankName;
  String? _accountType;

  final _totalInvestmentController = TextEditingController();
  final _ifscController = TextEditingController();
  final _accountNumberController = TextEditingController();

  // Dropdown options
  final List<String> planTypes = ['Direct', 'Regular'];

  final List<String> schemeCategories = [
    'Equity Fund',
    'Multi Assets',
    'Gold',
    'Debt',
    'Q Nifty',
    'Hybrid'
  ];

  final List<String> investmentTypes = [
    'Lump sum',
    'SIP only',
    'Lump sum + SIP'
  ];
  final List<String> holdingTypes = ['Non Demat', 'Demat'];

  final List<String> physicalCopyOptions = ['Yes', 'No'];

  final List<String> paymentModes = [
    'Net Banking',
    'RTGS/NEFT',
    'IMPS',
    'UPI-VPA',
    'URI-QR Scan'
  ];

  final List<String> bankNames = [
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'Punjab National Bank',
    'Kotak Mahindra Bank',
    'Bank of Baroda',
    'Canara Bank',
    'Union Bank of India',
    'IDFC First Bank',
    'Other'
  ];
  
  // Account type.
  final List<String> accountTypes = ['Savings', 'Current'];

 // Equity fund scheme options.
  final List<String> equityfundScheme = [
   'Quantum Value Fund - Regular Plan IDCW Payout Option',
   'Quantum Value Fund - Regular Plan IDCW Re-Investment Option',
   'Quantum Value Fund - Regular Plan Growth Option',
   'Quantum ELSS Tax Saver Fund - Regulat Plan IDCW ',
   'Quantum ELSS Tax Saver Fund - Regulat Plan Growth',
   'Quantum Equity Funds of Funds - Regular Plan IDCW Payout',
   'Quantum Equity Funds of Funds - Regular Plan IDCW Re-Investment',
   'Quantum Equity Funds of Funds - Regular Plan Growth',
   '',
   '',
   '',
  ];

// 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Investment Details',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Plan type
              _buildDropdown(
                label: 'The Plan',
                value: _plantype,
                items: planTypes,
                onChanged: (val) => setState(() => _plantype = val),
              ),
              // Scheme category
              _buildDropdown(
                label: 'Scheme Category',
                value: _schemeCategory,
                items: schemeCategories,
                onChanged: (val) => setState(() => _schemeCategory = val),
              ),
              // Investment type
              _buildDropdown(
                label: 'Investment Type',
                value: _investmentType,
                items: investmentTypes,
                onChanged: (val) => setState(() => _investmentType = val),
              ),
              // Total investment
              _buildTextField(
                controller: _totalInvestmentController,
                label: 'Total Investment',
                keyboardType: TextInputType.number,
              ),
              // Holding type
              _buildDropdown(
                label: 'Holding Type',
                value: _holdingType,
                items: holdingTypes,
                onChanged: (val) => setState(() => _holdingType = val),
              ),
              // Physical copy of annual report
              _buildDropdown(
                label: 'Physical Copy of Annual Report',
                value: _physicalCopy,
                items: physicalCopyOptions,
                onChanged: (val) => setState(() => _physicalCopy = val),
              ),
              // Mode of payment
              _buildDropdown(
                label: 'Mode of Payment',
                value: _paymentMode,
                items: paymentModes,
                onChanged: (val) => setState(() => _paymentMode = val),
              ),
              // Select bank name
              _buildDropdown(
                label: 'Select Bank Name',
                value: _bankName,
                items: bankNames,
                onChanged: (val) => setState(() => _bankName = val),
              ),
              // IFSC code
              _buildTextField(
                controller: _ifscController,
                label: 'IFSC Code',
              ),
              // Account number
              _buildTextField(
                controller: _accountNumberController,
                label: 'Account Number',
                keyboardType: TextInputType.number,
              ),
              // Account type
              _buildDropdown(
                label: 'Account Type',
                value: _accountType,
                items: accountTypes,
                onChanged: (val) => setState(() => _accountType = val),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission or navigation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Investment details saved!')),
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(token: ''),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map((val) => DropdownMenuItem(value: val, child: Text(val)))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Required' : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator ??
            (val) {
              if (val == null || val.isEmpty) return 'Required';
              return null;
            },
      ),
    );
  }
}