# guzzle-http debug response

```php
        try {
            $response = $this->getClient()->request($method, $uri, $options);
        } catch (ClientException $e) {
if (true) {
            throw $e;
} else {
            echo "\n*\n* REQUEST\n*\n";
            $request = $e->getRequest();
            echo Psr7\str($request);
            if ($e->hasResponse()) {
                echo "<br>\n";
                echo "\n*\n* RESPONSE\n*\n";
                echo Psr7\str($e->getResponse());
                echo "<br>printr<br>\n";
                print_r($e->getResponse()->getBody());
            }
                echo "<BR>REQUEST<br>\n";
            print_r (json_decode($request->getBody()));

            echo "\n*\n* MESSAGE\n*\n";
            echo $e->getMessage();
            echo "***\n";
            D();
}
        }

```