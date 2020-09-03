<?php
/**
 * Created by PhpStorm.
 * User: howie
 * Date: 24/09/17
 * Time: 12:07
 */

namespace Weathermap\Core;

/**
 * Class WMDebugLogging - debug logging enabled.
 */

class WMDebugLogging extends WMDebugNull
{
    public function log($string)
    {
        if (!$this->shouldLog($string)) {
            return;
        }

        if (func_num_args() > 1) {
            $args = func_get_args();
            $string = call_user_func_array('sprintf', $args);
        }

        $callingFunction = $this->getCallingFunction();

        $message = "DEBUG:$callingFunction " . ($this->contextName == '' ? '' : $this->contextName . ': ') . rtrim($string) . "\n";

        $this->doLog($message);
    }

    protected function doLog($message)
    {
        $stderr = fopen('php://stderr', 'w');
        fwrite($stderr, $message);
        fclose($stderr);
    }

    /**
     * @return string
     */
    private function getCallingFunction()
    {
        $callingFunction = '';

        if (function_exists('debug_backtrace')) {
            $backtrace = debug_backtrace();
            $index = 3;

            $function = (isset($backtrace[$index]['function'])) ? $backtrace[$index]['function'] : '';
            $index = 2;
            $file = (isset($backtrace[$index]['file'])) ? basename($backtrace[$index]['file']) : '';
            $line = (isset($backtrace[$index]['line'])) ? $backtrace[$index]['line'] : '';
            return " [$function@$file:$line]";
        }
        return $callingFunction;
    }

    protected function shouldLog($string)
    {
        global $weathermap_debugging_readdata;
        global $weathermap_debugging;

        $isReadData = false;

        if ($weathermap_debugging_readdata && false !== strpos('ReadData', $string)) {
            $isReadData = true;
        }
        return $weathermap_debugging || ($weathermap_debugging_readdata && $isReadData);
    }
}
