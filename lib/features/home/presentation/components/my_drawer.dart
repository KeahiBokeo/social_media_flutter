import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_flutter/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_flutter/features/home/presentation/components/my_drawer_tile.dart';
import 'package:social_media_flutter/features/profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 50),

              //logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              //divider line
              Divider(color: Theme.of(context).colorScheme.secondary),

              //home tile
              MyDrawerTile(
                title: "H O M E",
                icon: Icons.home,
                onTap: () => Navigator.of(context).pop(),
              ),

              //profile tile
              MyDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),

              //search tile
              MyDrawerTile(
                title: "S E A R C H",
                icon: Icons.search,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

              //setting tile
              MyDrawerTile(
                title: "S E T T I N G",
                icon: Icons.settings,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

              const Spacer(),
              //logout tile
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.login,
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AuthCubit>().logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
