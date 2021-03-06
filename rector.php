<?php
// rector.php

declare(strict_types=1);

use Rector\Core\Configuration\Option;
use Rector\Php74\Rector\Property\TypedPropertyRector;
use Rector\Set\ValueObject\SetList;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;

return static function (ContainerConfigurator $containerConfigurator): void {
    // get parameters
    $parameters = $containerConfigurator->parameters();

    // paths to refactor; solid alternative to CLI arguments
    $parameters->set(Option::PATHS, [
        __DIR__ . '/lib',
    ]);


    // here we can define, what sets of rules will be applied
    $parameters->set(Option::SETS, [
        SetList::CODE_QUALITY,
        SetList::PHPUNIT_60,
        SetList::PHPUNIT_70,
        SetList::PHPUNIT_80
    ]);

    // get services
    $services = $containerConfigurator->services();

    // register single rule
    $services->set(TypedPropertyRector::class);
};
