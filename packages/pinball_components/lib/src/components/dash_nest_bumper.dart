import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template dash_nest_bumper}
/// Bumper with a nest appearance.
/// {@endtemplate}
abstract class DashNestBumper extends BodyComponent with InitialPosition {
  /// {@macro dash_nest_bumper}
  DashNestBumper._({
    required String activeAssetPath,
    required String inactiveAssetPath,
    required SpriteComponent spriteComponent,
  })  : _activeAssetPath = activeAssetPath,
        _inactiveAssetPath = inactiveAssetPath,
        _spriteComponent = spriteComponent;

  final String _activeAssetPath;
  late final Sprite _activeSprite;
  final String _inactiveAssetPath;
  late final Sprite _inactiveSprite;
  final SpriteComponent _spriteComponent;

  Future<void> _loadSprites() async {
    // TODO(alestiago): I think ideally we would like to do:
    // Sprite(path).load so we don't require to store the activeAssetPath and
    // the inactive assetPath.
    _inactiveSprite = await gameRef.loadSprite(_inactiveAssetPath);
    _activeSprite = await gameRef.loadSprite(_activeAssetPath);
  }

  /// Activates the [DashNestBumper].
  void activate() {
    _spriteComponent
      ..sprite = _activeSprite
      ..size = _activeSprite.originalSize / 10;
  }

  /// Deactivates the [DashNestBumper].
  void deactivate() {
    _spriteComponent
      ..sprite = _inactiveSprite
      ..size = _inactiveSprite.originalSize / 10;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprites();

    // TODO(erickzanardo): Look into using onNewState instead.
    // Currently doing: onNewState(gameRef.read<GameState>()) will throw an
    // `Exception: build context is not available yet`
    deactivate();
    await add(_spriteComponent);
  }
}

/// {@macro dash_nest_bumper}
class BigDashNestBumper extends DashNestBumper {
  /// {@macro dash_nest_bumper}
  BigDashNestBumper()
      : super._(
          activeAssetPath: Assets.images.dashBumper.main.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.main.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
          ),
        );

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: 4.85,
      minorRadius: 3.95,
    )..rotate(math.pi / 2);
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@macro dash_nest_bumper}
class SmallDashNestBumper extends DashNestBumper {
  /// {@macro dash_nest_bumper}
  SmallDashNestBumper._({
    required String activeAssetPath,
    required String inactiveAssetPath,
    required SpriteComponent spriteComponent,
  }) : super._(
          activeAssetPath: activeAssetPath,
          inactiveAssetPath: inactiveAssetPath,
          spriteComponent: spriteComponent,
        );

  /// {@macro dash_nest_bumper}
  SmallDashNestBumper.a()
      : this._(
          activeAssetPath: Assets.images.dashBumper.a.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.a.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0.35, -1.2),
          ),
        );

  /// {@macro dash_nest_bumper}
  SmallDashNestBumper.b()
      : this._(
          activeAssetPath: Assets.images.dashBumper.b.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.b.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0.35, -1.2),
          ),
        );

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: 3,
      minorRadius: 2.25,
    )..rotate(math.pi / 2);
    final fixtureDef = FixtureDef(shape)
      ..friction = 0
      ..restitution = 4;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}