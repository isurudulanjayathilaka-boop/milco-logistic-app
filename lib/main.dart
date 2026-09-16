import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MilcoLogisticsApp());
}

// ----------------- User Roles & Access Control -----------------
enum UserRole { admin, factory, stores, lab, transport, purchasing, none }

class AppUser {
  final String email;
  final String password;
  final UserRole role;
  final String subCategory; // උදා: CMF, DMF ආදී වශයෙන් කර්මාන්තශාලාවක් වෙන් කිරීමට

  AppUser({
    required this.email,
    required this.password,
    required this.role,
    this.subCategory = '',
  });
}

// ලියාපදිංචි කර ඇති Gmail සහ Password ලැයිස්තුව
final List<AppUser> registeredUsers = [
  // 1. Admin (ඔයාට සම්පූර්ණ අයිතිය)
  AppUser(email: 'isurudulanjayathilaka@gmail.com', password: 'DULAN3397milco', role: UserRole.admin),

  // 2. Factory Users (8 දෙනෙක්)
  AppUser(email: 'cmf1@milco.lk', password: 'milco123', role: UserRole.factory, subCategory: 'CMF'),
  AppUser(email: 'cmf2@milco.lk', password: 'milco123', role: UserRole.factory, subCategory: 'CMF'),
  AppUser(email: 'dmf1@milco.lk', password: 'milco123', role: UserRole.factory, subCategory: 'DMF'),
  AppUser(email: 'dmf2@milco.lk', password: 'milco123', role: UserRole.factory, subCategory: 'DMF'),
  AppUser(email: 'pmf1@milco.lk', password: 'milco123', role: UserRole.factory, subCategory: 'PMF'),
  AppUser(email: 'pmf2@milco.lk', password: 'milco123', role: UserRole.factory, subCategory: 'PMF'),
  AppUser(email: 'sdmf1@milco.lk', password: 'milco123', role: UserRole.factory, subCategory: 'SDMF'),
  AppUser(email: 'sdmf2@milco.lk', password: 'milco123', role: UserRole.factory, subCategory: 'SDMF'),

  // 3. Main Stores Users (3 දෙනෙක්)
  AppUser(email: 'dulanjayathilaka62@gmail.com', password: 'DULAN3397milcO', role: UserRole.stores),
  AppUser(email: 'stores2@milco.lk', password: 'milco123', role: UserRole.stores),
  AppUser(email: 'stores3@milco.lk', password: 'milco123', role: UserRole.stores),

  // 4. Main Lab Users (2 දෙනෙක්)
  AppUser(email: 'lab1@milco.lk', password: 'milco123', role: UserRole.lab),
  AppUser(email: 'lab2@milco.lk', password: 'milco123', role: UserRole.lab),

  // 5. Transport Users (2 දෙනෙක්)
  AppUser(email: 'transport1@milco.lk', password: 'milco123', role: UserRole.transport),
  AppUser(email: 'transport2@milco.lk', password: 'milco123', role: UserRole.transport),

  // 6. Purchasing Users (3 දෙනෙක්)
  AppUser(email: 'purchasing1@milco.lk', password: 'milco123', role: UserRole.purchasing),
  AppUser(email: 'purchasing2@milco.lk', password: 'milco123', role: UserRole.purchasing),
  AppUser(email: 'purchasing3@milco.lk', password: 'milco123', role: UserRole.purchasing),
];

// වත්මන් ලොග් වී සිටින පරිශීලකයා
AppUser? currentUser;

class MilcoLogisticsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Milco Logistics & Inventory System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: LoginScreen(),
    );
  }
}

// ----------------- Login Screen (Email & Password Required) -----------------
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    String enteredEmail = _emailController.text.trim().toLowerCase();
    String enteredPassword = _passwordController.text.trim();
    
    var matchedUser = registeredUsers.firstWhere(
      (u) => u.email == enteredEmail && u.password == enteredPassword,
      orElse: () => AppUser(email: '', password: '', role: UserRole.none),
    );

    if (matchedUser.role != UserRole.none) {
      setState(() {
        currentUser = matchedUser;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogisticsHomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'වැරදි Email ලිපිනයක් හෝ Password එකකි!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_shipping, size: 60, color: Colors.blue[800]),
                  SizedBox(height: 10),
                  Text('Milco Logistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[900])),
                  Text('Email සහ Password ඇතුළත් කර පිවිසෙන්න', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Gmail ලිපිනය (Email)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 15),
                  if (_errorMessage.isNotEmpty)
                    Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 12)),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      minimumSize: Size(double.infinity, 45),
                    ),
                    onPressed: _login,
                    child: Text('Login (ඇතුළු වන්න)', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Create by Dulan Jayathilaka Soft Development',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------- Global Mock Data -----------------
class OrderModel {
  String orderId;
  String factory;
  String item;
  String quantity;
  String transportStatus;
  String vehicleNo;
  String transportDateTime;
  String labStatus; 
  String storeCompletion; 
  String remark; 

  OrderModel({
    required this.orderId,
    required this.factory,
    required this.item,
    required this.quantity,
    this.transportStatus = 'Pending',
    this.vehicleNo = '-',
    this.transportDateTime = '-',
    this.labStatus = 'Pending',
    this.storeCompletion = 'Active',
    this.remark = '-',
  });
}

List<OrderModel> globalOrders = [
  OrderModel(orderId: 'ORD-501', factory: 'CMF', item: 'Fresh Milk Packaging Film', quantity: '500 Rolls', transportStatus: 'Approved', vehicleNo: 'WP-KA-1234', transportDateTime: '2026-09-17 09:30 AM', labStatus: 'Released', storeCompletion: 'Active'),
  OrderModel(orderId: 'ORD-502', factory: 'DMF', item: 'Sugar Bags (50kg)', quantity: '200 Bags', transportStatus: 'Pending', vehicleNo: '-', transportDateTime: '-', labStatus: 'Pending', storeCompletion: 'Active'),
];

List<OrderModel> completedOrders = [];
const String milcoBgUrl = 'https://images.unsplash.com/photo-1557683316-973673baf926?auto=format&fit=crop&w=1000&q=80';

// ----------------- Dashboard Screen -----------------
class LogisticsHomeScreen extends StatefulWidget {
  @override
  _LogisticsHomeScreenState createState() => _LogisticsHomeScreenState();
}

class _LogisticsHomeScreenState extends State<LogisticsHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('yyyy-MM-dd | hh:mm a').format(DateTime.now());

    final List<Widget> pages = [
      DashboardHomeTab(currentDate: currentDate),
      CompletedOrdersTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Milco Logistics (${currentUser?.email} - ${currentUser?.role.name})'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Live Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Completed History'),
        ],
      ),
    );
  }
}

class DashboardHomeTab extends StatelessWidget {
  final String currentDate;
  DashboardHomeTab({required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(milcoBgUrl), 
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.85), BlendMode.lighten),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.blue[900], borderRadius: BorderRadius.circular(8)),
              child: Text(
                'වර්තමාන දිනය සහ වෙලාව: $currentDate',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 15),
            Text('සියලුම අංශ (සියලු දෙනාටම නැරඹිය හැක):', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700], padding: EdgeInsets.all(12)),
                    icon: Icon(Icons.store, color: Colors.white),
                    label: Text('Main Stores & Factory Requests', style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StoresScreen())).then((_) => (context as Element).reassemble()),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: EdgeInsets.all(12)),
                    icon: Icon(Icons.local_shipping, color: Colors.white),
                    label: Text('Purchasing & Transport Allocation', style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PurchasingScreen())).then((_) => (context as Element).reassemble()),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], padding: EdgeInsets.all(12)),
                    icon: Icon(Icons.science, color: Colors.white),
                    label: Text('Main Lab Quality Check & Release', style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LabScreen())).then((_) => (context as Element).reassemble()),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[700], padding: EdgeInsets.all(12)),
                    icon: Icon(Icons.factory, color: Colors.white),
                    label: Text('Factories Stock Sheets (CMF, DMF, PMF, SDMF)', style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FactoriesScreen())),
                  ),
                  SizedBox(height: 20),
                  Text('අද දින පවතින සක්‍රීය ඇනවුම් (${globalOrders.length}):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 10),
                  ...globalOrders.map((order) => Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text('${order.orderId} - ${order.factory} (${order.item})'),
                      subtitle: Text('ප්‍රමාණය: ${order.quantity} | වාහනය: ${order.vehicleNo} | ලැබ් තත්ත්වය: ${order.labStatus}'),
                      trailing: Chip(
                        label: Text(order.storeCompletion, style: TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: order.storeCompletion == 'Completed' ? Colors.green : Colors.amber[800],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- 1. Main Stores Screen -----------------
class StoresScreen extends StatefulWidget {
  @override
  _StoresScreenState createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  final String storesSheetUrl = 'https://docs.google.com/spreadsheets/d/1R44dyfjvTnr3CxE81IwYBPDBTxW8VzvxD5TJUEmiBjY/edit?usp=sharing';

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showCompleteDialog(OrderModel order, int index) {
    final remarkController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ඇනවුම සම්පූර්ණ කිරීම (Complete Order)'),
        content: TextField(
          controller: remarkController,
          maxLines: 3,
          decoration: InputDecoration(labelText: 'Remarks (විශේෂ සටහන ලියන්න)', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() {
                order.storeCompletion = 'Completed';
                order.remark = remarkController.text.isEmpty ? 'සටහනක් නොමැත' : remarkController.text;
                completedOrders.add(order);
                globalOrders.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Confirm Complete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canEdit = currentUser?.role == UserRole.admin || currentUser?.role == UserRole.stores;

    return Scaffold(
      appBar: AppBar(title: Text('Main Stores & Factory Requests'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.table_chart),
              label: Text('Open Main Stores Google Sheet'),
              onPressed: () => _launchURL(storesSheetUrl),
            ),
            SizedBox(height: 15),
            Text('ඉල්ලීම් සහ තත්ත්වය (Stores View):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: globalOrders.length,
                itemBuilder: (context, index) {
                  final order = globalOrders[index];
                  return Card(
                    child: ListTile(
                      title: Text('${order.orderId} - ${order.factory}: ${order.item} (${order.quantity})'),
                      subtitle: Text('Transport: ${order.transportStatus} | Lab: ${order.labStatus}'),
                      trailing: canEdit && order.labStatus == 'Released' && order.storeCompletion != 'Completed'
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              child: Text('Complete', style: TextStyle(color: Colors.white)),
                              onPressed: () => _showCompleteDialog(order, index),
                            )
                          : Text(order.storeCompletion, style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- 2. Purchasing & Transport Screen -----------------
class PurchasingScreen extends StatefulWidget {
  @override
  _PurchasingScreenState createState() => _PurchasingScreenState();
}

class _PurchasingScreenState extends State<PurchasingScreen> {
  @override
  Widget build(BuildContext context) {
    bool canEdit = currentUser?.role == UserRole.admin || currentUser?.role == UserRole.transport || currentUser?.role == UserRole.purchasing;

    return Scaffold(
      appBar: AppBar(title: Text('Purchasing & Transport Allocation'), backgroundColor: Colors.green),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: globalOrders.length,
        itemBuilder: (context, index) {
          final order = globalOrders[index];
          final vehicleController = TextEditingController(text: order.vehicleNo);
          final timeController = TextEditingController(text: order.transportDateTime);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${order.orderId} - ${order.factory} | ${order.item} (${order.quantity})', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(controller: vehicleController, enabled: canEdit, decoration: InputDecoration(labelText: 'වාහන අංකය (Vehicle No)')),
                  TextField(controller: timeController, enabled: canEdit, decoration: InputDecoration(labelText: 'දිනය සහ වේලාව (Date & Time)')),
                  SizedBox(height: 10),
                  if (canEdit)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Save Transport Details'),
                      onPressed: () {
                        setState(() {
                          order.transportStatus = 'Approved';
                          order.vehicleNo = vehicleController.text;
                          order.transportDateTime = timeController.text;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transport details updated!')));
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ----------------- 3. Main Lab Screen -----------------
class LabScreen extends StatefulWidget {
  @override
  _LabScreenState createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
  @override
  Widget build(BuildContext context) {
    bool canEdit = currentUser?.role == UserRole.admin || currentUser?.role == UserRole.lab;

    return Scaffold(
      appBar: AppBar(title: Text('Main Lab Quality Check'), backgroundColor: Colors.orange[800]),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: globalOrders.length,
        itemBuilder: (context, index) {
          final order = globalOrders[index];
          return Card(
            child: ListTile(
              title: Text('${order.orderId} - ${order.factory}: ${order.item}'),
              subtitle: Text('වත්මන් තත්ත්ව සහතිකය: ${order.labStatus}'),
              trailing: canEdit
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: Text('Release', style: TextStyle(color: Colors.white)),
                          onPressed: () => setState(() => order.labStatus = 'Released'),
                        ),
                        SizedBox(width: 5),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: Text('Reject', style: TextStyle(color: Colors.white)),
                          onPressed: () => setState(() => order.labStatus = 'Rejected'),
                        ),
                      ],
                    )
                  : Text(order.labStatus, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}

// ----------------- 4. Factories Google Sheets Screen -----------------
class FactoriesScreen extends StatefulWidget {
  @override
  _FactoriesScreenState createState() => _FactoriesScreenState();
}

class _FactoriesScreenState extends State<FactoriesScreen> {
  final String cmfUrl = 'https://docs.google.com/spreadsheets/d/1hkaPoRqc1i9DMiB7JUhSoRRbvBGbH0Yi0P8M5WNBE7c/edit?usp=sharing';
  final String dmfUrl = 'https://docs.google.com/spreadsheets/d/1h9JbP0Xi6yixba55WgO6mIbL6dcLhZyni2IFrXQFdBc/edit?usp=sharing';
  final String pmfUrl = 'https://docs.google.com/spreadsheets/d/12p3L_ZjABStf6v3seKqCEeXlQrlxkgCXuYdT2qS1kMU/edit?usp=sharing';
  final String sdmfUrl = 'https://docs.google.com/spreadsheets/d/1y-0Ku5bdm5CcBEqOa2Tymuj6nAeE0eMKlombnGi5UPQ/edit?usp=sharing';

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showNewRequestDialog() {
    final itemController = TextEditingController();
    final qtyController = TextEditingController();
    String factoryToRequest = currentUser?.subCategory.isNotEmpty == true 
        ? currentUser!.subCategory 
        : 'CMF';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('නව ඉල්ලීමක් ඇතුළත් කිරීම ($factoryToRequest)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: itemController, decoration: InputDecoration(labelText: 'අවශ්‍ය භාණ්ඩය (Item)')),
            TextField(controller: qtyController, decoration: InputDecoration(labelText: 'ප්‍රමාණය (Quantity)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                globalOrders.add(OrderModel(
                  orderId: 'ORD-${DateTime.now().millisecond}',
                  factory: factoryToRequest,
                  item: itemController.text,
                  quantity: qtyController.text,
                ));
              });
              Navigator.pop(context);
            },
            child: Text('Submit Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canRequest = currentUser?.role == UserRole.admin || currentUser?.role == UserRole.factory;

    return Scaffold(
      appBar: AppBar(title: Text('Factories Stock Sheets & Requests'), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('කර්මාන්තශාලා 4 හි Stock Sheets (සියලු දෙනාට නැරඹිය හැක):', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(onPressed: () => _launchURL(cmfUrl), child: Text('1. CMF Stock Sheet')),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () => _launchURL(dmfUrl), child: Text('2. DMF Stock Sheet')),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () => _launchURL(pmfUrl), child: Text('3. PMF Stock Sheet')),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () => _launchURL(sdmfUrl), child: Text('4. SDMF Stock Sheet')),
            SizedBox(height: 20),
            if (canRequest)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[800], padding: EdgeInsets.all(12)),
                icon: Icon(Icons.add),
                label: Text('New Factory Request (ඉල්ලීමක් යැවීම)'),
                onPressed: _showNewRequestDialog,
              ),
          ],
        ),
      ),
    );
  }
}

// ----------------- Completed Orders History Tab -----------------
class CompletedOrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('අසම්පූර්ණ කර අවසන් වූ (Completed) ඇනවුම් ඉතිහාසය:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Expanded(
            child: completedOrders.isEmpty
                ? Center(child: Text('තවම අවසන් කළ ඇනවුම් නොමැත.', style: TextStyle(color: Colors.grey[600])))
                : ListView.builder(
                    itemCount: completedOrders.length,
                    itemBuilder: (context, index) {
                      final order = completedOrders[index];
                      return Card(
                        color: Colors.green[50],
                        child: ListTile(
                          title: Text('${order.orderId} - ${order.factory} (${order.item})'),
                          subtitle: Text('ප්‍රමාණය: ${order.quantity} | වාහනය: ${order.vehicleNo}\nRemarks: ${order.remark}'),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
