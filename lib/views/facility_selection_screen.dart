import 'package:chefaa_frontend/models/user_role.dart';
import 'package:chefaa_frontend/providers/register_providers.dart';
import 'package:chefaa_frontend/views/register_doctor_screen.dart';
import 'package:chefaa_frontend/views/widgets/role_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FacilitySelectionScreen extends StatelessWidget {
  const FacilitySelectionScreen({super.key});

 @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegisterProviders>();
    final selectedRole = provider.selectedRole;
    final isSelected = selectedRole == UserRole.pharmacy || selectedRole == UserRole.lab;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF0066CC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Text(
                  'Chefaa',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Choose Facility',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  RoleCard(
                    userRole: UserRole.pharmacy,
                    isSelected: selectedRole == UserRole.pharmacy,
                    icon: Icons.medication_outlined,
                    onTap: () => provider.selectRole(UserRole.pharmacy),
                  ),
                  RoleCard(
                    userRole: UserRole.lab,
                    isSelected: selectedRole == UserRole.lab,
                    icon: Icons.science_outlined,
                    onTap: () => provider.selectRole(UserRole.lab),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: isSelected
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterDoctorScreen(),
                            ),
                          );
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}