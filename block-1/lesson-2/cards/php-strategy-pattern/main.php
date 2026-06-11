<?php

declare(strict_types=1);

interface Exporter
{
    public function export(array $data): string;
}

final class CsvExporter implements Exporter
{
    public function export(array $data): string
    {
        return implode(',', $data);
    }
}

final class JsonExporter implements Exporter
{
    public function export(array $data): string
    {
        return json_encode($data);
    }
}

function report(Exporter $exporter, array $data): string
{
    return $exporter->export($data);
}
