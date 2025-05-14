import 'package:docveda_app/utils/helpers/date_formater.dart';
import 'package:docveda_app/utils/helpers/format_amount.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

Future<void> generateAndShowPdf(List<Map<String, dynamic>> selectedPatients) async {
  final pdf = pw.Document();

  // Define one set of headers and rows per screen type
  final Map<String, List<List<String>>> screenWiseData = {};
  final Map<String, List<String>> screenWiseHeaders = {
    'admission': ['Name', 'Age', 'Gender', 'UHID No', 'Admission Date', 'Total Bill', 'Ward Name', 'Bed Name'],
    'discharge': ['Name', 'Age', 'Gender', 'UHID No', 'Admission Date', 'Discharge Date', 'Bill Amount', 'Ward', 'Bed'],
    'ipd settlement': ['Name',  'UHID No', 'Admission Date', 'Total Ipd Bill', 'Deposit','Final Settlement','Refund Amount', 'Discount Amount', 'Discharge Date', 'Doctor Name'],
    'deposit': ['Name', 'Age', 'Gender', 'UHID No', 'Admission Date', 'Deposit', 'Total Ipd Bill','Pending Amount', ],
    'bed transfer': ['Name', 'Age', 'Gender', 'UHID No', 'Transfer Date', 'From Ward', 'To Ward', 'Bed Shift'],
    'opd visit': ['Name', 'Age', 'Gender', 'UHID No', 'Visit Date',  'Doctor Name', ],
    'opd payment': ['Name', 'Age', 'Gender', 'UHID No', 'Bill Amount','Payment Date', 'Paid Amount', 'Doctor Name', ],
    'opd bills': ['Name', 'Age', 'Gender', 'UHID No', 'Admission Date', 'Bill Amount', 'Bill No', ],
    'refund': ['Name', 'Age', 'Gender', 'UHID No', 'Refund Date', 'Refund Amount', 'N/A', ],
    'discount': ['Name', 'Age', 'Gender', 'UHID No', 'Discount Date', 'Discount Amount', ],
  };

  for (final patient in selectedPatients) {
    final screenName = (patient['Screen Name'] ?? '').toString().toLowerCase();
    final data = <String>[];

    switch (screenName) {
      case 'admission':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Admission Date']),
          FormatAmount.formatAmount(patient['Total IPD Bill']?.toString() ?? '0'),
          patient['Ward Name'] ?? '--',
          patient['Bed Name'] ?? '--',
        ]);
        break;
      case 'discharge':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Admission Date']),
          DateFormatter.formatDate(patient['Discharge Date']),
          FormatAmount.formatAmount(patient['Bill Amount']?.toString() ?? '0'),
          patient['Ward Name'] ?? '--',
          patient['Bed Name'] ?? '--',
        ]);
        break;
      case 'ipd settlement':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Admission Date']),
          FormatAmount.formatAmount(patient['Total IPD Bill']?.toString() ?? '0'),
          FormatAmount.formatAmount(patient['Deposit']?.toString() ?? '0'),
          FormatAmount.formatAmount(patient['Final Settlement']?.toString() ?? '0'),
          FormatAmount.formatAmount(patient['Refund Amount']?.toString() ?? '0'),
          FormatAmount.formatAmount(patient['Discount Amount']?.toString() ?? '0'),
          DateFormatter.formatDate(patient['Discharge Date']),
          patient['Doctor Name'] ?? '--',
        
        ]);
        break;
      case 'deposit':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Admission Date']),
           FormatAmount.formatAmount(patient['Total IPD Bill']?.toString() ?? '0'),
          FormatAmount.formatAmount(patient['Deposit']?.toString() ?? '0'),
          FormatAmount.formatAmount(patient['Pending Amount']?.toString() ?? '0'),
          patient['Bed Name'] ?? '--',
        ]);
        break;
      case 'bed transfer':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Bed Transfer Date']),
          patient['From Ward'] ?? '--',
          patient['To Ward'] ?? '--',
          '${patient['From Bed'] ?? '--'} → ${patient['To Bed'] ?? '--'}',
        ]);
        break;
      case 'opd visit':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Visit Date']),
          patient['Doctor Name'] ?? '--',
         
        ]);
        break;
      case 'opd payment':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Date Of Payment']),
          FormatAmount.formatAmount(patient['Paid Amount']?.toString() ?? '0'),
          patient['Doctor Name'] ?? '--',
          FormatAmount.formatAmount(patient['Bill Amount']?.toString() ?? '0'),
         
        ]);
        break;
      case 'opd bills':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Admission Date']),
          FormatAmount.formatAmount(patient['Bill Amount']?.toString() ?? '0'),
          patient['Bill No'] ?? '--',
         
        ]);
        break;
      case 'refund':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Date Of Refund']),
          FormatAmount.formatAmount(patient['Refund Amount']?.toString() ?? '0'),
          
        ]);
        break;
      case 'discount':
        data.addAll([
          patient['Patient Name'] ?? '--',
          patient['Age'] ?? '--',
          patient['Gender'] ?? '--',
          patient['UHID No'] ?? '--',
          DateFormatter.formatDate(patient['Date Of Discount']),
          FormatAmount.formatAmount(patient['Discount Amount']?.toString() ?? '0'),
          
        ]);
        break;
      default:
        continue;
    }

    if (!screenWiseData.containsKey(screenName)) {
      screenWiseData[screenName] = [];
    }
    screenWiseData[screenName]!.add(data);
  }

  // Add a page per screen type
  for (final entry in screenWiseData.entries) {
    final screen = entry.key;
    final data = entry.value;
    final headers = screenWiseHeaders[screen] ?? [];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            '${screen[0].toUpperCase()}${screen.substring(1)} Report',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            border: pw.TableBorder.all(color: PdfColors.grey),
            cellHeight: 25,
          ),
        ],
      ),
    );
  }

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
