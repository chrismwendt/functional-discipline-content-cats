module ArbitraryOption:
  Bastet.Test.ARBITRARY_A with
    type t('a) = option('a) and type arbitrary('a) = QCheck.arbitrary('a) = {
  type t('a) = option('a);
  type arbitrary('a) = QCheck.arbitrary('a);
  let make = QCheck.option;
  let make_bound = value => QCheck.option(value);
};

module ArbitraryOptionInt:
  Bastet.Test.ARBITRARY with
    type t = option(int) and type arbitrary('a) = QCheck.arbitrary('a) = {
  type t = option(int);
  type arbitrary('a) = QCheck.arbitrary('a);
  let make = QCheck.option(QCheck.int);
};

module TestOption =
  Bastet.Test.Option(
    AlcotestI.Test,
    QCheckI.Quickcheck,
    ArbitraryOptionInt,
    ArbitraryOption,
  );

let suites = TestOption.suites;
