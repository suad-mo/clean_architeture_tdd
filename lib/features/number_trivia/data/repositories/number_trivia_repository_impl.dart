import 'package:clean_architeture_tdd/core/error/exceptions.dart';
import 'package:dartz/dartz.dart';

import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../../../../core/platform/network_info.dart';
import '../../../../core/error/failures.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTrivialLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(
      int number) async {
    networkInfo.isConnected;
    try {
      final remoteTrivia =
          await remoteDataSource.getConcreteNumberTrivia(number);
      localDataSource.casheNumberTrivia(remoteTrivia!);
      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    return null;
  }
}
