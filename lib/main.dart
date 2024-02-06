import 'package:flutter/material.dart';
import 'package:helpdesk_apps/pages/change_pass.dart';
import 'package:helpdesk_apps/pages/homepage.dart';
import 'package:helpdesk_apps/pages/karyawan/add_new_report.dart';
import 'package:helpdesk_apps/pages/karyawan/report_list.karyawan.dart';
import 'package:helpdesk_apps/pages/login.dart';
import 'package:helpdesk_apps/pages/register.dart';
import 'package:helpdesk_apps/pages/secondpage.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:helpdesk_apps/repository/auth.repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AuthRepo.generatePassword(password: 'teknisi123').then((res) {
    print(res.msg);
  });

  final prefs = await SharedPreferences.getInstance();

  String? pid = prefs.getString('pid');

  var initPage = pid == null ? '/login_page' : '/';
  // var initPage = '/login_page';

  runApp(MyApp(
    initPage: initPage,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.initPage,
  });

  final String initPage;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // HIJAU  = 0xFF3A6344
    // COKLAT = 0xFF291E0B
    // CREAM  = 0xFFF1EDEF
    Map<int, Color> color = {
      50: const Color.fromRGBO(29, 48, 34, 1),
      100: const Color.fromRGBO(36, 61, 42, 1),
      200: const Color.fromRGBO(38, 64, 44, 1),
      300: const Color.fromRGBO(44, 74, 51, 1),
      400: const Color.fromRGBO(51, 87, 60, 1),
      500: const Color.fromRGBO(41, 122, 96, 1),
      600: const Color.fromRGBO(74, 125, 87, 1),
      700: const Color.fromRGBO(89, 150, 104, 1),
      800: const Color.fromRGBO(104, 176, 122, 1),
      900: const Color.fromRGBO(119, 201, 140, 1),
    };
    MaterialColor myColor = MaterialColor(0xFF3A6344, color);
    return MaterialApp(
      title: 'Moman',
      initialRoute: initPage,
      theme: ThemeData(
        primarySwatch: myColor,
      ),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSwatch().copyWith(
      //     primary: const Color(0xFF3A6344),
      //   ),
      // ),
      // home: const MainContainer(),
      routes: {
        '/': (context) => const MainContainer(),
        '/login_page': (context) => const LoginPage(),
        '/register_page': (context) => const Register(),
        '/add_new_report': (context) => const AddNewReport(),
        '/reset_password': (context) => const ChangePassword(),
      },
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  String role = 'teknisi';
  @override
  Widget build(BuildContext context) {
    List<String> _titleList = <String>[
      'REPORT LIST',
      'SECOND PAGE',
    ];

    List<Widget> _widgetList = <Widget>[
      ReportListKaryawan(),
      SecondPage(),
    ];

    List<BottomNavigationBarItem> _bottomNavList = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.library_books_outlined), label: 'Report List'),
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Second Page'),
    ];

    // if (role == 'teknisi') {
    //   _titleList = <String>['HELPDESK', 'LIST REPORT'];
    //   _widgetList = <Widget>[HomePage(),SecondPage()];
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: Text(
        //   _titleList.elementAt(_selectedIndex),
        //   style: const TextStyle(fontWeight: FontWeight.bold),
        // ),
        elevation: 0,
        title: Row(
          children: [
            // Image.asset(
            //   'assets/icon/logo_notance_no_bg.png',
            //   fit: BoxFit.cover,
            //   height: 32,
            // ),
            const SizedBox(
              width: 8,
            ),
            Text(
              // _titleList.elementAt(_selectedIndex),
              _titleList.elementAt(_selectedIndex),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF1EDEF),
                // backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
              ),
            ),
          ],
        ),
        shape: const Border(
            bottom: BorderSide(
          color: Color(0xFF3A6344),
          width: 1,
        )),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthRepo.authSignout().then((res) {
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(res.msg)));
                if (res.success) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login_page', (route) => false);
                }
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const ReportListKaryawan(),
      // body: _widgetList.elementAt(_selectedIndex),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: _bottomNavList,
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
