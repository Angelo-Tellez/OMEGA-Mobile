// ============================================================
// Company    : OMEGA Solutions (OMEGA)
// Project    : ATN - Sistema de Control de Asistencias
// File       : perfil_screen.dart
// Created on : 24/04/2026
// Created by : Jorge Alejandro Martinez Toris
// Reviewed by: Ximena Becerril Olivares
// ------------------------------------------------------------
// Changelog:
//   [001] 24/04/2026 - Jorge Alejandro Martinez Toris - Pantalla de perfil (solo lectura)
//   [002] 24/04/2026 - Jorge Alejandro Martinez Toris - Integracion con paypal
//   [003] 21/05/2026 - Jorge Alejandro Martinez Toris - Modo edicion de datos del perfil
//   [004] 22/05/2026 - Jorge Alejandro Martinez Toris - Suscripcion dinamica desde API
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/connection/api_client.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../features/auth/bloc/auth_bloc.dart';
import '../../../../features/auth/bloc/auth_event.dart';
import '../../../../features/auth/bloc/auth_state.dart';
import '../../../../features/auth/data/usuario_model.dart';
import '../../../../features/suscripcion/data/suscripcion_model.dart';

class PerfilScreen extends StatefulWidget
{
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen>
{
  final _formKey   = GlobalKey<FormState>();
  bool  _editando  = false;
  bool  _guardando = false;

  SuscripcionModel? _suscripcion;
  bool _cargandoSuscripcion = false;

  late TextEditingController _nombreCtrl;
  late TextEditingController _apPatCtrl;
  late TextEditingController _apMatCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;

  @override
  void initState()
  {
    super.initState();
    _nombreCtrl   = TextEditingController();
    _apPatCtrl    = TextEditingController();
    _apMatCtrl    = TextEditingController();
    _emailCtrl    = TextEditingController();
    _passwordCtrl = TextEditingController();
    _cargarSuscripcion();
  }

  Future<void> _cargarSuscripcion() async
  {
    if (!mounted) return;
    setState(() => _cargandoSuscripcion = true);
    try {
      final resp = await ApiClient.instance.get(ApiRoutes.suscripcion);
      final data = (resp.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      if (mounted) setState(() => _suscripcion = SuscripcionModel.fromJson(data));
    } catch (_) {
      // Si falla, simplemente no mostramos la suscripcion
    } finally {
      if (mounted) setState(() => _cargandoSuscripcion = false);
    }
  }

  @override
  void dispose()
  {
    _nombreCtrl.dispose();
    _apPatCtrl.dispose();
    _apMatCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _iniciarEdicion(UsuarioModel usuario)
  {
    _nombreCtrl.text   = usuario.nombre;
    _apPatCtrl.text    = usuario.apPat;
    _apMatCtrl.text    = usuario.apMat ?? '';
    _emailCtrl.text    = usuario.email;
    _passwordCtrl.text = '';
    setState(() => _editando = true);
  }

  void _cancelarEdicion() => setState(() => _editando = false);

  void _guardar()
  {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);
    context.read<AuthBloc>().add(PerfilActualizado(
      nombre:   _nombreCtrl.text.trim(),
      apPat:    _apPatCtrl.text.trim(),
      apMat:    _apMatCtrl.text.trim().isEmpty ? null : _apMatCtrl.text.trim(),
      email:    _emailCtrl.text.trim(),
      password: _passwordCtrl.text.isEmpty ? null : _passwordCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state)
      {
        if (!_guardando) return;

        if (state is AuthSuccess) {
          setState(() { _editando = false; _guardando = false; });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:         Text('Perfil actualizado correctamente.'),
              backgroundColor: AppColors.electricBlue,
              behavior:        SnackBarBehavior.floating,
            ),
          );
        } else if (state is AuthFailure) {
          setState(() => _guardando = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:         Text(state.mensaje),
              backgroundColor: AppColors.actionRed,
              behavior:        SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state)
      {
        if (state is! AuthSuccess) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryCoral)),
          );
        }

        final usuario = state.usuario;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon:      const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: _editando ? _cancelarEdicion : () => context.pop(),
            ),
            title: Text(_editando ? 'Editar perfil' : 'Mi perfil'),
            actions: [
              if (!_editando)
                IconButton(
                  icon:      const Icon(Icons.edit_outlined),
                  tooltip:   'Editar perfil',
                  onPressed: () => _iniciarEdicion(usuario),
                )
              else
                SizedBox(
                  width: 90,
                  child: TextButton(
                    onPressed: _guardando ? null : _guardar,
                    child: _guardando
                        ? const SizedBox(
                            width:  18,
                            height: 18,
                            child:  CircularProgressIndicator(
                              strokeWidth: 2,
                              color:       AppColors.primaryCoral,
                            ),
                          )
                        : const Text(
                            'Guardar',
                            style:    TextStyle(color: AppColors.primaryCoral),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
            ],
          ),
          body: SafeArea(
            child: _editando
                ? _buildFormEdicion(usuario)
                : _buildVistaLectura(context, usuario),
          ),
        );
      },
    );
  }

  // ── VISTA LECTURA ─────────────────────────────────────────

  Widget _buildVistaLectura(BuildContext context, UsuarioModel usuario)
  {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      children: [
        _buildAvatarSection(context, usuario),
        const SizedBox(height: AppSizes.paddingL),
        _buildInfoSection(context, usuario),
        const SizedBox(height: AppSizes.paddingL),
        _buildRolSection(context, usuario),
        if (usuario.isDocente) ...[
          const SizedBox(height: AppSizes.paddingL),
          _buildSuscripcionSection(context),
        ],
        const SizedBox(height: AppSizes.paddingXL),
        _buildLogoutButton(context),
        const SizedBox(height: AppSizes.paddingL),
      ],
    );
  }

  Widget _buildAvatarSection(BuildContext context, UsuarioModel usuario)
  {
    final iniciales = '${usuario.nombre[0]}${usuario.apPat[0]}'.toUpperCase();

    return Center(
      child: Column(
        children: [
          Container(
            width:  88,
            height: 88,
            decoration: const BoxDecoration(
              color: AppColors.primaryCoral,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                iniciales,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize:   AppSizes.fontH1,
                  color:      AppColors.baseSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(
            '${usuario.nombre} ${usuario.apPat}${usuario.apMat != null ? ' ${usuario.apMat}' : ''}',
            style:     Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            usuario.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, UsuarioModel usuario)
  {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos personales',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color:      AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),
          _InfoRowWidget(icon: Icons.badge_outlined,  label: 'Nombre',             valor: usuario.nombre),
          const Divider(color: AppColors.surface, height: AppSizes.paddingL),
          _InfoRowWidget(icon: Icons.badge_outlined,  label: 'Apellido paterno',   valor: usuario.apPat),
          const Divider(color: AppColors.surface, height: AppSizes.paddingL),
          _InfoRowWidget(icon: Icons.badge_outlined,  label: 'Apellido materno',   valor: usuario.apMat ?? '—'),
          const Divider(color: AppColors.surface, height: AppSizes.paddingL),
          _InfoRowWidget(icon: Icons.email_outlined,  label: 'Correo electronico', valor: usuario.email),
        ],
      ),
    );
  }

  Widget _buildRolSection(BuildContext context, UsuarioModel usuario)
  {
    final esDocente = usuario.isDocente;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color:        AppColors.baseSurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.surface),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingS),
            decoration: BoxDecoration(
              color:        AppColors.cloudBlue,
              borderRadius: BorderRadius.circular(AppSizes.radiusInput),
            ),
            child: Icon(
              esDocente ? Icons.person_rounded : Icons.school_rounded,
              color: AppColors.deepNavy,
              size:  AppSizes.iconM,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tipo de cuenta',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutralGrey,
                ),
              ),
              Text(
                esDocente ? 'Docente' : 'Alumno',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color:      AppColors.deepNavy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuscripcionSection(BuildContext context)
  {
    final sus         = _suscripcion;
    final esMensual   = sus?.isMensual  ?? false;
    final nombrePlan  = sus?.nombrePlan ?? 'Plan Basico';
    final subtitulo   = esMensual
        ? (sus?.fechaFin != null ? 'Activo hasta ${sus!.fechaFin}' : 'Plan activo')
        : 'Toca para mejorar tu plan';
    final colorBorde  = esMensual ? AppColors.successGreen : AppColors.headingDark;
    final colorIcono  = esMensual ? AppColors.successGreen : AppColors.headingDark;

    return GestureDetector(
      onTap: () async {
        await context.push(AppRouter.suscripcion);
        _cargarSuscripcion(); // recarga al volver
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        decoration: BoxDecoration(
          color:        AppColors.cloudBlue,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
          border:       Border.all(color: colorBorde),
        ),
        child: Row(
          children: [
            if (_cargandoSuscripcion)
              const SizedBox(
                width:  AppSizes.iconM,
                height: AppSizes.iconM,
                child:  CircularProgressIndicator(
                  strokeWidth: 2,
                  color:       AppColors.primaryCoral,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingS),
                decoration: BoxDecoration(
                  color:        colorIcono,
                  borderRadius: BorderRadius.circular(AppSizes.radiusInput),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: AppColors.baseSurface,
                  size:  AppSizes.iconM,
                ),
              ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombrePlan,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:      AppColors.deepNavy,
                    ),
                  ),
                  Text(
                    subtitulo,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutralGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.headingDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context)
  {
    return SizedBox(
      width:  double.infinity,
      height: AppSizes.heightButton,
      child:  OutlinedButton.icon(
        onPressed: ()
        {
          context.read<AuthBloc>().add(const AuthLogoutRequested());
          context.go(AppRouter.login);
        },
        icon:  const Icon(Icons.logout_rounded, color: AppColors.actionRed),
        label: const Text('Cerrar sesion'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.actionRed,
          side:  const BorderSide(color: AppColors.actionRed),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButton),
          ),
        ),
      ),
    );
  }

  // ── FORMULARIO EDICIÓN ────────────────────────────────────

  Widget _buildFormEdicion(UsuarioModel usuario)
  {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        children: [
          // Avatar (solo visual, no editable)
          Center(
            child: Container(
              width:  88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.primaryCoral,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${usuario.nombre[0]}${usuario.apPat[0]}'.toUpperCase(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize:   AppSizes.fontH1,
                    color:      AppColors.baseSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),

          // Datos personales
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color:        AppColors.baseSurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              border:       Border.all(color: AppColors.surface),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Datos personales',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:      AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                _buildCampo(
                  controller: _nombreCtrl,
                  label:      'Nombre',
                  icono:      Icons.badge_outlined,
                  validator:  (v) => (v == null || v.trim().isEmpty) ? 'El nombre es requerido' : null,
                ),
                const SizedBox(height: AppSizes.paddingM),
                _buildCampo(
                  controller: _apPatCtrl,
                  label:      'Apellido paterno',
                  icono:      Icons.badge_outlined,
                  validator:  (v) => (v == null || v.trim().isEmpty) ? 'El apellido paterno es requerido' : null,
                ),
                const SizedBox(height: AppSizes.paddingM),
                _buildCampo(
                  controller: _apMatCtrl,
                  label:      'Apellido materno (opcional)',
                  icono:      Icons.badge_outlined,
                ),
                const SizedBox(height: AppSizes.paddingM),
                _buildCampo(
                  controller:   _emailCtrl,
                  label:        'Correo electronico',
                  icono:        Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'El correo es requerido';
                    if (!v.contains('@'))              return 'Ingresa un correo valido';
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),

          // Cambio de contraseña (opcional)
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color:        AppColors.baseSurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusCard),
              border:       Border.all(color: AppColors.surface),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cambiar contrasena',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:      AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingXS),
                Text(
                  'Dejalo en blanco si no deseas cambiarla.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:    AppColors.neutralGrey,
                    fontSize: AppSizes.fontCaption,
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                _buildCampo(
                  controller: _passwordCtrl,
                  label:      'Nueva contrasena',
                  icono:      Icons.lock_outline_rounded,
                  obscure:    true,
                  validator: (v) {
                    if (v != null && v.isNotEmpty && v.length < 6) {
                      return 'Minimo 6 caracteres';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.paddingXL),

          // Botón guardar
          SizedBox(
            width:  double.infinity,
            height: AppSizes.heightButton,
            child:  ElevatedButton(
              onPressed: _guardando ? null : _guardar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryCoral,
                foregroundColor: AppColors.baseSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                ),
              ),
              child: _guardando
                  ? const SizedBox(
                      width:  20,
                      height: 20,
                      child:  CircularProgressIndicator(strokeWidth: 2, color: AppColors.baseSurface),
                    )
                  : const Text('Guardar cambios'),
            ),
          ),
          const SizedBox(height: AppSizes.paddingM),

          // Botón cancelar
          SizedBox(
            width:  double.infinity,
            height: AppSizes.heightButton,
            child:  OutlinedButton(
              onPressed: _guardando ? null : _cancelarEdicion,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.neutralGrey,
                side:  const BorderSide(color: AppColors.surface),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusButton),
                ),
              ),
              child: const Text('Cancelar'),
            ),
          ),
          const SizedBox(height: AppSizes.paddingL),
        ],
      ),
    );
  }

  Widget _buildCampo({
    required TextEditingController controller,
    required String                label,
    required IconData              icono,
    TextInputType                  keyboardType = TextInputType.text,
    bool                           obscure      = false,
    String? Function(String?)?     validator,
  })
  {
    return TextFormField(
      controller:   controller,
      keyboardType: keyboardType,
      obscureText:  obscure,
      validator:    validator,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.deepNavy),
      decoration: InputDecoration(
        labelText:  label,
        prefixIcon: Icon(icono, size: AppSizes.iconS, color: AppColors.headingDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide:   const BorderSide(color: AppColors.surface),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide:   const BorderSide(color: AppColors.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide:   const BorderSide(color: AppColors.primaryCoral, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide:   const BorderSide(color: AppColors.actionRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInput),
          borderSide:   const BorderSide(color: AppColors.actionRed, width: 1.5),
        ),
        filled:     true,
        fillColor:  AppColors.baseSurface,
        labelStyle: TextStyle(color: AppColors.neutralGrey, fontSize: AppSizes.fontBody),
      ),
    );
  }
}

// ── WIDGET AUXILIAR ───────────────────────────────────────

class _InfoRowWidget extends StatelessWidget
{
  final IconData icon;
  final String   label;
  final String   valor;

  const _InfoRowWidget({
    required this.icon,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context)
  {
    return Row(
      children: [
        Icon(icon, size: AppSizes.iconS, color: AppColors.headingDark),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:    AppColors.neutralGrey,
                  fontSize: AppSizes.fontCaption,
                ),
              ),
              Text(
                valor,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:      AppColors.deepNavy,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
