// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Wall', () {
    group('BottomWallBallContactCallback', () {
      test(
        'removes the ball on begin contact when the wall is a bottom one',
        () {
          final game = MockPinballGame();
          final wall = MockBottomWall();
          final ball = MockBall();

          when(() => ball.gameRef).thenReturn(game);

          BottomWallBallContactCallback()
            // Remove once https://github.com/flame-engine/flame/pull/1415
            // is merged
            ..end(MockBall(), MockBottomWall(), MockContact())
            ..begin(ball, wall, MockContact());

          verify(ball.lost).called(1);
        },
      );
    });
    final flameTester = FlameTester(PinballGame.new);

    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final wall = Wall(
          start: Vector2.zero(),
          end: Vector2(100, 0),
        );
        await game.ensureAdd(wall);

        expect(game.contains(wall), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);
          game.contains(wall);

          expect(wall.body.position, Vector2.zero());
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);

          expect(wall.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('first fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);

          expect(wall.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'has restitution equals 0',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);

          final fixture = wall.body.fixtures[0];
          expect(fixture.restitution, equals(0));
        },
      );

      flameTester.test(
        'has friction',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);

          final fixture = wall.body.fixtures[0];
          expect(fixture.friction, greaterThan(0));
        },
      );
    });
  });
}