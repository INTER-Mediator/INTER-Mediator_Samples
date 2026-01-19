<?php
/**
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt
 *
 * @copyright     Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * @link          https://inter-mediator.com/
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */

require_once '../vendor/inter-mediator/inter-mediator/INTER-Mediator.php';

IM_Entry(
    [
        [
            'name' => 'person-list',
            'view' => 'person',
            'table' => 'person',
            'key' => 'person_id',
            'records' => 200,
            'maxrecords' => 100000,
            'paging' => true,
            'repeat-control' => 'confirm-insert confirm-delete confirm-copy',
            'navi-control' => 'master-hide',
            'button-names' => ['insert' => '新規作成'],
        ],
        [
            'name' => 'person-detail',
            'view' => 'person',
            'table' => 'person',
            'key' => 'person_id',
            'records' => 1,
            'maxrecords' => 1,
            'navi-control' => 'detail',
            'calculation' => [
                ['field' => 'photo_style', 'expression' => "if(photo, 'block', 'none')"],
            ],
            'authentication' => ['media-handling' => true],
        ],
    ],
    [
        'media-root-dir' => '/tmp',
        'authentication' => [
//            'group' => ['admin'],
            'authexpired' => '60000', // Set as seconds.
            'storing' => 'credential',
        ],
    ],
    ['db-class' => 'PDO',],
    2
);

