import 'package:flutter/material.dart';
import 'package:manage_x/core/responsive/responsive_layout_wrapper.dart';
import 'package:manage_x/core/widgets/custom_button.dart';
import 'package:manage_x/core/widgets/custom_form_field.dart';
import 'package:manage_x/features/auth/presentation/widgets/custom_design.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const LoginMobileView(),
      web: const LoginWebView(),
    );
  }
}
class LoginMobileView extends StatefulWidget {
  const LoginMobileView({super.key});

  @override
  State<LoginMobileView> createState() => _LoginMobileViewState();
}

class _LoginMobileViewState extends State<LoginMobileView> {
   final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                CustomTopDesign(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
      
                      Align(
                        alignment: AlignmentGeometry.bottomLeft,
                        child: Text("Welcome \nBack",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),)),
                      SizedBox(height: 20,),
                      CustomTextField(
                        
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
              
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.email_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Password TextField
              CustomTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                prefixIcon: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
             
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF6366F1),
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
                      const SizedBox(height: 30),
                     CustomButton(
                      labelColor: Colors.white,
                      backgroundColor: const Color(0xFF0B1F5A),
                      label: "Login", onPressed: (){})
                    ],
                  ),
                ),
              ],
            ),
      
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomRightDesign(),
            ),
          ],
        ),
      ),
    );
  }
}
class LoginWebView extends StatelessWidget {
  const LoginWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBF2FF),
      body: Stack(
        
        clipBehavior: Clip.none,
        children: [
         Positioned(
  top: 0,
  left: 65,
  child: SizedBox(
    width: 220,
    height: 220,
    child: CustomDottedBackground(),
  ),
),

Positioned(
  bottom: 0,
  right: 65,
  child: SizedBox(
    width: 220,
    height: 220,
    child: CustomDottedBackground(),
  ),
),

Positioned(
  top: 0,
  right: 0,
  child: CustomTopRightDesign(),
),
Positioned(
  bottom: 0,
  left: 0,
  child: CustomBottomLeftDesign(),
),



            Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 550,
            minHeight: 550,
          ),
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // TOP DESIGN INSIDE CARD
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CustomTopDesign(),
                ),

                // FORM CONTENT
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 140, 32, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(),
                      const SizedBox(height: 16),
                      TextFormField(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),

                // BOTTOM RIGHT DESIGN INSIDE CARD
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CustomBottomRightDesign(),
                ),
              ],
            ),
          ),
        ),
      ),
        ],
      )
    );
  }
}
