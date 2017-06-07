package akamai

import (
	"fmt"
	"testing"

	"github.com/hashicorp/terraform/helper/resource"
	"github.com/hashicorp/terraform/terraform"
)

func TestAccAkamaiGTMDomainBasic(t *testing.T) {
	resource.Test(t, resource.TestCase{
		PreCheck:  func() { testAccPreCheck(t) },
		Providers: testAccProviders,
		//CheckDestroy: testAccAkamaiGTMDomainDestroy,
		Steps: []resource.TestStep{
			resource.TestStep{
				Config: testAccCheckAkamaiGtmDomainConfigBasic,
				Check: resource.ComposeTestCheckFunc(
					testAccCheckAkamaiGTMDomainExists("akamai_gtm_domain.test_domain"),
					resource.TestCheckResourceAttr("akamai_gtm_domain.test_domain", "name", "golangtest.akadns.net"),
					resource.TestCheckResourceAttr("akamai_gtm_domain.test_domain", "type", "weighted"),
				),
			},
		},
	})
}

func testAccAkamaiGTMDomainDestroy(s *terraform.State) error {
	return nil
}

func testAccCheckAkamaiGTMDomainExists(n string) resource.TestCheckFunc {
	return func(s *terraform.State) error {
		rs, ok := s.RootModule().Resources[n]
		if !ok {
			return fmt.Errorf("Not found %s", rs)
		}

		if rs.Primary.ID == "" {
			return fmt.Errorf("No domain ID is set")
		}

		client := testAccProvider.Meta().(*Clients).GTM

		readDomain, err := client.Domain(rs.Primary.ID)

		if err != nil {
			return err
		}

		if readDomain.Name != rs.Primary.ID {
			return fmt.Errorf("Domain not found")
		}

		return nil
	}
}

const testAccCheckAkamaiGtmDomainConfigBasic = `
resource "akamai_gtm_domain" "test_domain" {
	name = "golangtest.akadns.net"
	type = "weighted"
}`
