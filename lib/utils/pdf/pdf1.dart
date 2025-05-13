import 'package:docveda_app/utils/helpers/date_formater.dart';
import 'package:docveda_app/utils/helpers/format_amount.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

Future<void> generateAndShowPdf(List<Map<String, dynamic>> selectedPatients) async {
  final pdf = pw.Document();
  final numberFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return [
          pw.Text(
            'Patient Report',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          ...selectedPatients.map((patient) {
            final screenName = (patient['Screen Name'] ?? '').toString().toLowerCase();
            final name = patient['Patient Name'] ?? '--';

            final reportData = <String, String>{
              'Name': name,
              'Age': patient['Age'] ?? '--',
              'Gender': patient['Gender'] ?? '--',
              'UHID No': patient['UHID No'] ?? '--',
            };

            switch (screenName) {
              case 'admission':
                reportData.addAll({
                  'Admission Date': DateFormatter.formatDate(patient['Admission Date']),
                  'Deposite':FormatAmount.formatAmount( patient['Deposite'] ?? '--'),
                  'Total IPD Bill': FormatAmount.formatAmount(patient['Total IPD Bill']?.toString() ?? '0'),
                  'Ward Name': patient['Ward Name'] ?? '--',
                  'Bed Name': patient['Bed Name'] ?? '--',
                });
                break;
              case 'discharge':
                reportData.addAll({
                  'Admission Date': DateFormatter.formatDate(patient['Admission Date']),
                  'Discharge Date': DateFormatter.formatDate(patient['Discharge Date']),
                  'Bill Amount': numberFormatter.format(num.tryParse(patient['Bill Amount']?.toString() ?? '0')),
                });
                break;
              case 'ipd settlement':
                reportData.addAll({
                  'Admission Date': DateFormatter.formatDate(patient['Admission Date']),
                  'Discharge Date': DateFormatter.formatDate(patient['Discharge Date']),
                  'Total IPD Bill': numberFormatter.format(num.tryParse(patient['Total IPD Bill']?.toString() ?? '0')),
                  'Final Settlement': patient['Final Settlement'] ?? '--',
                  'Refund Amount': numberFormatter.format(num.tryParse(patient['Refund Amount']?.toString() ?? '0')),
                  'Discount Amount': numberFormatter.format(num.tryParse(patient['Discount Amount']?.toString() ?? '0')),
                  'Doctor Name': patient['Doctor Name'] ?? '--',
                });
                break;
              case 'opd visit':
                reportData.addAll({
                  'Visit Date': DateFormatter.formatDate(patient['Visit Date']),
                  'Doctor Name': patient['Doctor Name'] ?? '--',
                });
                break;
              case 'deposit':
                reportData.addAll({
                  'Admission Date': DateFormatter.formatDate(patient['Admission Date']),
                  'Deposit': numberFormatter.format(num.tryParse(patient['Deposit']?.toString() ?? '0')),
                  'Pending Amount': numberFormatter.format(num.tryParse(patient['Pending Amount']?.toString() ?? '0')),
                });
                break;
              case 'bed transfer':
                reportData.addAll({
                  'Bed Transfer Date': DateFormatter.formatDate(patient['Bed Transfer Date']),
                  'Bed Transfer Time': patient['Bed Transfer Time'] ?? '--',
                  'From Ward': patient['From Ward'] ?? '--',
                  'To Ward': patient['To Ward'] ?? '--',
                  'From Bed': patient['From Bed'] ?? '--',
                  'To Bed': patient['To Bed'] ?? '--',
                });
                break;
              case 'opd payment':
                reportData.addAll({
                  'Admission Date': DateFormatter.formatDate(patient['Admission Date']),
                  'Bill Amount': numberFormatter.format(num.tryParse(patient['Bill Amount']?.toString() ?? '0')),
                  'Date Of Payment': DateFormatter.formatDate(patient['Date Of Payment']),
                  'Paid Amount': numberFormatter.format(num.tryParse(patient['Paid Amount']?.toString() ?? '0')),
                  'Refund': numberFormatter.format(num.tryParse(patient['Refund']?.toString() ?? '0')),
                  'Discount': numberFormatter.format(num.tryParse(patient['Discount']?.toString() ?? '0')),
                  'Doctor Name': patient['Doctor Name'] ?? '--',
                });
                break;
              case 'opd bills':
                reportData.addAll({
                  'Admission Date': DateFormatter.formatDate(patient['Admission Date']),
                  'Bill Amount': numberFormatter.format(num.tryParse(patient['Bill Amount']?.toString() ?? '0')),
                  'Bill No': patient['Bill No'] ?? '--',
                });
                break;
              case 'refund':
                reportData.addAll({
                  'Admission Date': DateFormatter.formatDate(patient['Admission Date']),
                  'Refund Amount': numberFormatter.format(num.tryParse(patient['Refund Amount']?.toString() ?? '0')),
                  'Date Of Refund': DateFormatter.formatDate(patient['Date Of Refund']),
                });
                break;
              case 'discount':
                reportData.addAll({
                  'Admission Date': DateFormatter.formatDate(patient['Admission Date']),
                  'Discount Amount': numberFormatter.format(num.tryParse(patient['Discount Amount']?.toString() ?? '0')),
                  'Date Of Discount': DateFormatter.formatDate(patient['Date Of Discount']),
                });
                break;
            }

            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${screenName.toUpperCase()} REPORT',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                ...reportData.entries.map((entry) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('${entry.key}:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(entry.value),
                      ],
                    ),
                  );
                }),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 10),
              ],
            );
          }).toList(),
        ];
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
