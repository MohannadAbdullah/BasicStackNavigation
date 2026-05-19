import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Container(
            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,

              borderRadius: BorderRadius.circular(25),

              boxShadow: const [
                BoxShadow(blurRadius: 10, color: Colors.black12),
              ],
            ),

            child: Form(
              key: formKey,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Text(
                    "Create Account",

                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),

                  // ================= NAME =================
                  TextFormField(
                    controller: nameController,

                    decoration: InputDecoration(
                      labelText: "Name",

                      prefixIcon: const Icon(Icons.person),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter name";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ================= EMAIL =================
                  TextFormField(
                    controller: emailController,

                    decoration: InputDecoration(
                      labelText: "Email",

                      prefixIcon: const Icon(Icons.email),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter email";
                      }

                      if (!value.contains("@")) {
                        return "Invalid email";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ================= PASSWORD =================
                  TextFormField(
                    controller: passwordController,

                    obscureText: obscure,

                    decoration: InputDecoration(
                      labelText: "Password",

                      prefixIcon: const Icon(Icons.lock),

                      suffixIcon: IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off,
                        ),

                        onPressed: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter password";
                      }

                      if (value.length < 6) {
                        return "Password too short";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // ================= BUTTON =================
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF87743B),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),

                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            // ✅ إنشاء الحساب
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                                  email: emailController.text.trim(),

                                  password: passwordController.text.trim(),
                                );

                            // ✅ المستخدم الحالي
                            final user = userCredential.user;

                            // ✅ حفظ البيانات في Firestore
                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(user!.uid)
                                .set({
                                  "name": nameController.text.trim(),

                                  "email": emailController.text.trim(),

                                  "role": "user",
                                });

                            // ✅ رسالة نجاح
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Account Created Successfully"),
                              ),
                            );

                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message ?? "Error")),
                            );
                          }
                        }
                      },

                      child: const Text(
                        "Create Account",

                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
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
